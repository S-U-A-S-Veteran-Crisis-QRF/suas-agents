# KMS Key Management & Envelope Encryption Runbook

_Author: Gemini (Gem), 2026-10-24. Status: review. See CONDUCTOR_REVIEW.md — ARNs below are placeholders; SUAS has no production AWS account yet._

## 1. Executive Summary & Purpose
This document defines the key management lifecycle and envelope encryption specification for the S.U.A.S. Veteran Crisis QRF (SUAS) platform backend (PostgreSQL 16 + FHIR R4). All Protected Health Information (PHI) and Personally Identifiable Information (PII) within FHIR R4 resource payloads (`Resource.text`, demographic attributes, geocoordinates) MUST be encrypted at rest using envelope encryption before database persistence.

This architecture enforces data minimization and zero-trust storage requirements while preserving data privacy prior to CalAIM provider enrollment.

## 2. Key Architecture & Hierarchy

SUAS uses a two-tier key hierarchy:

1. **Key Encryption Key (KEK) / Root KMS Key**
   - Managed inside AWS KMS (or HashiCorp Vault for self-hosted / air-gapped setups).
   - Never leaves the Hardware Security Module (HSM) boundary.
   - Used exclusively to encrypt and decrypt Data Encryption Keys (DEKs).
   - KMS Key Alias: `alias/suas-p0-fhir-kek`
   - ARN: `arn:aws:kms:us-west-2:<AWS_ACCOUNT_ID>:key/<KEY_UUID>` (placeholder until the SUAS AWS account exists)

2. **Data Encryption Key (DEK)**
   - Cryptographically random 256-bit symmetric key generated via AWS KMS `GenerateDataKey` (`AES_256`).
   - Used by the Node.js / TypeScript API service layer to encrypt/decrypt individual FHIR R4 resource payloads.
   - Plaintext DEK resides strictly in ephemeral application RAM during processing and is zeroed (`Buffer.fill(0)`) immediately after cipher operations.
   - Encrypted DEK (ciphertext blob) is stored alongside the encrypted payload in the PostgreSQL `fhir_r4.encrypted_resources` table.

## 3. Envelope Encryption Implementation (TypeScript / Node.js)

```typescript
import { KMSClient, GenerateDataKeyCommand, DecryptCommand } from "@aws-sdk/client-kms";
import * as crypto from "crypto";

const kmsClient = new KMSClient({ region: "us-west-2" });
const KEK_ARN = process.env.SUAS_KMS_KEK_ARN; // never hardcode

export interface EncryptedPayload {
  ciphertextData: string; // Base64 AES-256-GCM ciphertext
  encryptedKey: string;   // Base64 KMS-encrypted DEK
  iv: string;             // Base64 IV (12 bytes)
  authTag: string;        // Base64 auth tag (16 bytes)
}

export async function encryptFHIRPayload(payloadJson: string): Promise<EncryptedPayload> {
  const kmsResponse = await kmsClient.send(
    new GenerateDataKeyCommand({ KeyId: KEK_ARN, KeySpec: "AES_256" })
  );
  if (!kmsResponse.Plaintext || !kmsResponse.CiphertextBlob) {
    throw new Error("KMS_DEK_GENERATION_FAILED: KMS returned empty key payload");
  }
  const plainDEK = Buffer.from(kmsResponse.Plaintext);
  const encryptedDEK = Buffer.from(kmsResponse.CiphertextBlob).toString("base64");

  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv("aes-256-gcm", plainDEK, iv);
  let encrypted = cipher.update(payloadJson, "utf8", "base64");
  encrypted += cipher.final("base64");
  const authTag = cipher.getAuthTag().toString("base64");

  plainDEK.fill(0);
  return { ciphertextData: encrypted, encryptedKey: encryptedDEK, iv: iv.toString("base64"), authTag };
}

export async function decryptFHIRPayload(p: EncryptedPayload): Promise<string> {
  const kmsResponse = await kmsClient.send(
    new DecryptCommand({ CiphertextBlob: Buffer.from(p.encryptedKey, "base64"), KeyId: KEK_ARN })
  );
  if (!kmsResponse.Plaintext) {
    throw new Error("KMS_DEK_DECRYPTION_FAILED: Unable to decrypt DEK with KEK");
  }
  const plainDEK = Buffer.from(kmsResponse.Plaintext);
  const decipher = crypto.createDecipheriv("aes-256-gcm", plainDEK, Buffer.from(p.iv, "base64"));
  decipher.setAuthTag(Buffer.from(p.authTag, "base64"));
  let decrypted = decipher.update(p.ciphertextData, "base64", "utf8");
  decrypted += decipher.final("utf8");
  plainDEK.fill(0);
  return decrypted;
}
```

## 4. Rotation Policy & Key Lifecycle

**Automated annual KEK rotation.** Every 365 days, configured in AWS KMS via `enable_key_rotation = true` (Terraform/CloudFormation). AWS KMS retains older backing key material, so decryption of existing stored DEKs continues without bulk re-encryption.

**Emergency DEK re-encryption (compromise).** If application credentials or backend infrastructure are compromised: trigger KEK rotation or create a new KEK; run the re-encryption utility (`npm run security:reencrypt-deks`) to pull active records, decrypt DEKs with the old KEK, re-encrypt with the new KEK, and update `fhir_r4.encrypted_resources`.

## 5. Break-Glass / Emergency Key Revocation

1. Disable the KEK immediately: `aws kms disable-key --key-id <KEK_ARN> --region us-west-2`
2. Verify lockout: all backend decryption calls throw `KMS.DisabledException`.
3. Audit: query CloudTrail for `kms:Decrypt` and `kms:GenerateDataKey` events in the suspect window.
