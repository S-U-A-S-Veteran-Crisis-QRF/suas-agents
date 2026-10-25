# TASKS.md — the board

Statuses: `open` · `claimed — <agent> — <date>` · `review` · `blocked` · `done`
Claim one at a time. Deliverables go in `work/<id>/`. See AGENTS.md §2.

---

## T-001 · CalAIM Community Supports provider enrollment packet (SCFHP)
**Best agent:** Claude · **Status:** open · **Priority:** P0
Assemble the full provider enrollment application for Santa Clara Family Health Plan Community Supports (Housing Transition/Navigation, Medically Supportive Food, Non-Medical Transportation). Produce the checklist, every form filled with ORG_IDENTIFIERS.md data, the policies SCFHP requires, and a `READY_FOR_HUMAN.md` telling Jacob and Jose exactly what to sign and where to submit.

## T-002 · Pilot operations paperwork kit
**Best agent:** Claude · **Backup:** ChatGPT · **Status:** open · **Priority:** P0
Consent form, incident log template, weekly outcome report template, volunteer dispatcher checklist, and a data-handling one-pager for the 25–50 veteran Santa Clara pilot. No PII fields beyond what's necessary; use VET-### IDs. Plain language, printable.

## T-003 · Orphaned P0 security items — plan and patches
**Best agent:** ChatGPT / OpenAI or Gemini · **Backup:** Claude · **Status:** review — Gemini (Gem) — 2026-10-24 · **Priority:** P0
For the SCC platform (PostgreSQL 16 + FHIR R4, React/Vite frontend): write the KMS key-management runbook, RLS default-deny migration, and user-level access revocation procedure. Deliver as reviewable patches/docs. Nothing goes to production without human review (AGENTS.md §3).
- **Did:** Gemini delivered KMS runbook + TypeScript envelope-encryption module, RLS default-deny SQL migration, access-revocation SOP, and READY_FOR_HUMAN. Filed in `work/T-003/`. (Gemini signed as "ChatGPT / OpenAI"; corrected here.)
- **Needs a human:** Jacob — run the SQL on a staging Postgres 16 first. See conductor notes in `work/T-003/CONDUCTOR_REVIEW.md` before anything touches production.
- **Next:** Claude reconciles the migration against the real SCC v2.0 schema and pgTAP suite, then T-011-style second opinion from a different model.

## T-004 · Website upgrade spec + donation page
**Best agent:** Meta Muse · **Backup:** Claude · **Status:** review — Meta Muse — 2026-10-24 · **Priority:** P1
Spec and build the suasqrf.org upgrade and donation page in repo `suas-webapp`. Must satisfy Google Ad Grants website policy (the earlier rejection was on website policy). Keep all claims within AGENTS.md §4.
- **Did (Meta Muse):** Donation page live on suasqrf.org Oct 24 — $25 / $150 / $210 tiers, EIN, 501(c)(3) status, Benevity matching link (cause 840-883249428), Reveal fix so middle sections show by default. Spec FILED Oct 25 in `work/T-004/` — `website-upgrade-spec.md`, `READY_FOR_HUMAN.md`, `reveal-redeploy-2026-10-25.md`, `CHANGES.md` (all return 200 via raw main). Evidence: https://suasqrf.org/donate/ (200), https://raw.githubusercontent.com/S-U-A-S-Veteran-Crisis-QRF/suas-agents/main/work/T-004/website-upgrade-spec.md (200).
- **Needs a human:** Claude — check the spec and live page against AGENTS.md §4 and Google Ad Grants policy, then close T-004 or return findings. Jacob's unfreeze decision is already made and executed: Oct 25, "Unfreeze only to redeploy the other Reveal pages" — 14 Reveal pages redeployed and verified live (0 `class="reveal"` occurrences, all new chunks 200); site returns to frozen unless Jacob reopens it. Jacob's separate decisions (not T-004): branch protection for gh-pages, adding Muse's GitHub App to suas-agents.
- **Next:** Claude checks the page against AGENTS.md §4 and Ad Grants policy; then T-005 status (see T-005 below).

## T-000 · Stand up the Agent Hub in GitHub
**Best agent:** Claude · **Status:** done — Claude — 2026-10-25 · **Priority:** P0
Public repo created by Claude via GitHub web on 2026-10-25: https://github.com/S-U-A-S-Veteran-Crisis-QRF/suas-agents . Muse: no commit to `suas-webapp/agents/` needed; file the T-004 spec here under `work/T-004/` instead.

## T-005 · Google Ad Grants account to live
**Best agent:** Meta Muse (owner) · **Status:** claimed — Meta Muse — 2026-10-23 · **Priority:** P1
Complete Ad Grants setup, resubmit after T-004, and report status here. Claude stays out of the Google Ads account.
- **Did (Meta Muse):** Account activated Oct 23, 2026, and restructured the same evening into 3 Search-only, Maximize Conversions campaigns, $329/day total: Donations (US targeting since Oct 24 evening), Get Help (Santa Clara County only), Brand (US targeting since Oct 24 evening). Call and Messaging Ads terms accepted Oct 25 (Click-to-Call + Lead form ads, both verified Accepted; call asset now editable, asset itself unchanged). No ad-policy disapprovals found in the Oct 25 live check. Full status filed in `work/T-004/website-upgrade-spec.md` (Ad Grants section) and in the daily report log for Oct 25.
- **Pending (Meta Muse):** Traffic is still zero — Oct 23, Oct 24 (full day), and Oct 25 morning: 0 impressions, 0 clicks, $0 spend, 0 conversions, account-wide. Two account-side issues remain: (1) a "missing a primary conversion action" diagnostic persists on Donations + Brand despite an Oct 24 settings fix; (2) Brand's new ad-group keywords are all "Low search volume". Keyword widening + goal-wiring fix was offered to Jacob Oct 25 and awaits his go. No payment details have been entered.
- **Google response since the earlier rejection (Meta Muse):** No new rejection. The account was activated Oct 23 and campaigns are Eligible (Donations + Brand Eligible (Limited), Get Help Eligible (Learning)); the only account issue shown Oct 25 is "Advertiser verification — Client verification recommended", which is non-blocking and not acted on. No resubmission is outstanding on the website-policy point — the T-004 page work is filed for Claude's §4 / policy check (see T-004).
- **Needs a human:** Jacob — approve the keyword + goal-wiring fix (T-005 follow-up, not a site edit). Jacob's separate decisions (not T-005): branch protection for gh-pages, adding Muse's GitHub App to suas-agents.
- **Next:** On Jacob's go, widen keywords and re-wire the goal diagnostic, then re-check traffic in the next daily report.

## T-006 · Veteran-community social signal feed
**Best agent:** Grok · **Status:** open · **Priority:** P2
Weekly digest of Santa Clara County / Bay Area veteran events, stand-downs, ERG activity, and crisis-adjacent trends from X and public sources. Format: `work/T-006/YYYY-WW.md`, ten items max, each with link and one line on why SUAS should care. No individual veteran's posts or identities.

## T-007 · Hardware in-kind pipeline — ERG contact list
**Best agent:** Grok · **Backup:** ChatGPT · **Status:** review — unsigned agent — 2026-10-25 · **Priority:** P2
Find publicly listed veteran ERG leads and IT asset disposition contacts at Bay Area companies (20–40). Public info only. Output a table; Claude drafts the one-message outreach; a human sends.
- **Did:** 20-company ERG/ITAD target directory filed at `work/T-007/ERG_TARGET_LIST.md` (unsigned; relayed by Jacob).
- **Needs a human:** nobody yet. Not sendable until T-014 adds a public contact channel per company.
- **Next:** T-014 (public intake channel + source per company), then Claude drafts outreach.

## T-008 · Hermes host hardware confirmation
**Best agent:** Hermes · **Status:** blocked · **Priority:** P1
Blocked until Hermes runs on org-controlled hardware (Beelink or equivalent). Once it does: post the machine's non-sensitive identity (hostname, OS, owner = SUAS) in `work/T-008/` and the conductor lifts the demo-grade restriction.

## T-009 · iOS app release checklist
**Best agent:** ChatGPT / OpenAI · **Backup:** Claude · **Status:** open · **Priority:** P1
Everything needed to move the operator-loop demo to a TestFlight build once Apple org enrollment (submitted 2026-10-23) is approved: bundle config, privacy nutrition labels, App Store listing copy within AGENTS.md §4 truth rules.

## T-010 · DOL VETS Stand Down FY2027 — watch and package
**Best agent:** Claude · **Status:** claimed — Claude — 2026-10-24 · **Priority:** P1
Scheduled watch already runs Mon/Thu. When the NOFO posts, finalize the quarterly "SUAS Mobile Stand Down" $10k application package and hand to Jacob via READY_FOR_HUMAN.md.

## T-011 · Second-opinion review of T-001 packet
**Best agent:** ChatGPT / OpenAI · **Status:** open (blocked by T-001) · **Priority:** P1
Adversarial read of the CalAIM packet: missing documents, inconsistent facts, claims that violate AGENTS.md §4. Deliver a findings list, not a rewrite.

## T-012 · Board one-pager: "How SUAS runs on agents"
**Best agent:** Claude · **Status:** open · **Priority:** P2
One page for Jose and Brant explaining this repo, the gates, and what they'll be asked to sign each month. No jargon.

## T-013 · Reconcile T-003 security patches against the real SCC schema
**Best agent:** Claude · **Status:** open · **Priority:** P0
Rewrite `work/T-003/RLS_DEFAULT_DENY_MIGRATION.sql` against the actual SCC v2.0 PostgreSQL schema, audit every veteran-data table for ENABLE+FORCE RLS with no permissive leftovers, fix the profiles-policy recursion, and run the pgTAP suite green. Output: a migration a human can run on staging.

## T-014 · ERG/ITAD directory — add one public contact channel per company
**Best agent:** Grok · **Backup:** Gemini / ChatGPT · **Status:** review — Gemini — 2026-10-25 · **Priority:** P2
For each of the 20 companies in `work/T-007/ERG_TARGET_LIST.md`: the one public channel that accepts nonprofit hardware/in-kind requests (program page URL, request form, or published giving inbox), the ERG name confirmed against a public page, and the named ITAD vendor if any. Table with a Source column for every row. No personal emails or private contacts. Output: `work/T-007/CONTACT_CHANNELS.md`.
- **Did:** Gemini delivered the 20-row matrix (signed correctly). Claude fetched every URL: 2 verified corporate channels (Lockheed, Oracle), 3 verified ITAD partners (TechSoup, Human-I-T, SVDE), 7 bot-blocked, 5 dead, 5 generic. Filed with per-row verdicts; Claude wrote 6 filled messages in `work/T-007/OUTREACH_FILLED.md`.
- **Needs a human:** Jacob — see `work/T-007/READY_FOR_HUMAN.md`: one TechSoup order, four single sends, one Cisco page to open.
- **Next:** Jacob names 3 companies for LinkedIn ERG notes; Claude drafts them. Dead/blocked rows stay closed unless a human verifies the page.

---

### Done
- T-000 · Agent Hub stood up in GitHub (Claude, 2026-10-25)
