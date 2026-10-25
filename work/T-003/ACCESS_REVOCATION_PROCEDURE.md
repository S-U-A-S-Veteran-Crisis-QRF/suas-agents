# User & System Access Revocation Procedure

_Author: Gemini (Gem), 2026-10-24. Status: review. Steps 3–4 are usable today for human offboarding; steps 1–2 depend on the real SCC schema and session store (see CONDUCTOR_REVIEW.md)._

## 1. Scope & Objective
Mandatory steps to immediately revoke a person's access across all SUAS systems (PostgreSQL 16 database, session store, Google Workspace, GitHub) on offboarding, role change, or security incident.

## 2. Emergency Lockout Sequence

### Step 1: PostgreSQL account deactivation (< 2 minutes)
```sql
-- Deactivate profile (instantly fails RLS policies)
UPDATE app_users.profiles SET is_active = FALSE, updated_at = NOW()
WHERE user_id = 'TARGET_USER_UUID_HERE';

-- Terminate active database connections for the user
SELECT pg_terminate_backend(pid) FROM pg_stat_activity
WHERE usename = 'TARGET_DB_USER' AND pid <> pg_backend_pid();
```

### Step 2: Session & JWT revocation (< 3 minutes)
Stateless JWTs stay valid until expiry, so active sessions are invalidated centrally (Redis shown; confirm SCC's actual session store):
```typescript
import { redisClient } from "../lib/redis";
export async function revokeUserSessions(userId: string): Promise<void> {
  await redisClient.set(`user:revoked:${userId}`, Date.now().toString(), "EX", 86400 * 7);
  await redisClient.del(`user:refreshtoken:${userId}`);
}
```

### Step 3: Identity provider & email (< 5 minutes)
1. Google Workspace Admin Console (admin.google.com) → Users → select account → **Suspend user**.
2. **Sign out of all sessions** and **Reset sign-in cookies**.

### Step 4: GitHub organization & repositories (< 5 minutes)
1. https://github.com/orgs/S-U-A-S-Veteran-Crisis-QRF/people → select user → **Remove from organization**.
2. Audit deploy keys, repository secrets, and personal access tokens tied to that person or to service accounts they controlled.

## 3. Post-revocation audit checklist
- [ ] Profile `is_active = FALSE` in `app_users.profiles`
- [ ] Active PostgreSQL connections terminated
- [ ] Session revocation entry confirmed in the session store
- [ ] Google Workspace account suspended, sessions reset
- [ ] GitHub org access removed; secrets and keys audited
- [ ] AWS IAM keys rotated/deleted (if the person had cloud permissions)
- [ ] Incident logged in the security audit record (no veteran PII)
