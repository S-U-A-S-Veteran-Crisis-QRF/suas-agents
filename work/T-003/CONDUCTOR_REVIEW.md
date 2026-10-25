# T-003 — Conductor review (Claude, 2026-10-24)

Gemini's three deliverables are a solid first draft and worth keeping. They are **not** ready to run against production. Findings, in order of risk:

1. **Invented AWS account ID.** The KMS ARN `arn:aws:kms:us-west-2:883249428:key/suas-p0-fhir-kek` uses the SUAS EIN digits as the AWS account number and a key *alias* where a key *ID (UUID)* belongs. SUAS does not yet have a production AWS account (TechSoup AWS credit is still being requested). Treat every ARN in the runbook as a placeholder to be replaced when the account exists. Nothing in the runbook should be copied into config as-is.
2. **Schema is invented, not the real one.** The migration creates its own `app_users`, `fhir_r4`, `dispatch_logs` schemas. The real SCC v2.0 PostgreSQL schema (with the 201-assertion pgTAP suite) already exists. Before running, the migration must be rewritten against the actual tables, and the pgTAP suite must pass. Running this file as-is on the real DB would create parallel empty tables and apply RLS to nothing that matters.
3. **No default-deny on existing tables.** "Default deny" here only covers the three new tables. The real requirement is `ENABLE ROW LEVEL SECURITY` + `FORCE ROW LEVEL SECURITY` on *every* table holding veteran-related data, with no permissive policy left over. That audit is the actual P0.
4. **RLS policy recursion risk.** Policies on `app_users.profiles` query `app_users.profiles` inside `USING`. With `FORCE ROW LEVEL SECURITY` this can recurse or silently deny. Standard fix: a `SECURITY DEFINER` helper that reads the caller's role, or a JWT claim set via `current_setting`.
5. **Redis is assumed.** The JWT revocation step assumes a Redis session store. Confirm SCC actually has one; if not, the revocation step is a no-op.
6. **Good:** envelope encryption pattern (KMS DEK + AES-256-GCM, DEK zeroed) is correct; access-revocation SOP checklist is usable now for human offboarding regardless of code.

## Disposition
- Keep all three files as the design baseline.
- Open follow-on: **T-013 — Reconcile T-003 against real SCC schema** (Claude, with pgTAP run) before any human runs SQL.
- Human gate unchanged: nothing applies to production without Jacob's review (AGENTS.md §3).

## Attribution
Work was produced by a Gemini Gem that signed as "ChatGPT / OpenAI". Recorded here as Gemini.
