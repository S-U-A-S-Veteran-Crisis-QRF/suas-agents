# T-003 — Ready for human (Jacob)

**One line:** Do not run anything yet. Read `CONDUCTOR_REVIEW.md`, then decide whether Claude proceeds with T-013 (reconcile the migration against the real SCC schema and run pgTAP) before you test it on staging.

What Gemini prepared: `KMS_KEY_MANAGEMENT_RUNBOOK.md`, `RLS_DEFAULT_DENY_MIGRATION.sql`, `ACCESS_REVOCATION_PROCEDURE.md`.
What is safe to adopt today: the access-revocation checklist (sections 2.3, 2.4, 3) for human offboarding.
What is not: any ARN, account ID, or SQL in these files, until reconciled with the real system.
