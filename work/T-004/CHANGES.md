# T-004 — CHANGES.md

Per AGENTS.md §10: file, what changed, why. One line per change. No secrets, no account numbers.

## suas-webapp (source, main)
- `components/Reveal.tsx` — Server render carries no `reveal` class; reveal class only added after JS mounts, with in-view immediate show and 1s fallback. Why: the old `.reveal{opacity:0}` + JS-only `.in` left /donate's middle blank on any JS/observer failure.
- `app/layout.tsx` — Noscript style forcing `.reveal` visible retained as belt-and-braces. Why: content must be visible with no JavaScript at all.
- `app/donate/page.tsx` — Workplace-giving line added, then linked to the public Benevity profile (causes/840-883249428). Why: employer-matching visibility for Ad Grants / donation conversion.
- `docs/donate-reveal-blank-fix-2026-10-24.md` (main commit 030a812) — Handoff note for the next agent: symptom, root cause, both fix attempts, verification, deploy pattern. Why: so Claude or another agent can fix the same issue without re-diagnosing it.

## suas-webapp (live site, gh-pages) — deploy notes, not source changes
- Oct 24, gh-pages final f7471da — /donate only: index.html, index.txt, and chunk page-c8c80093ff9eb60f.js with the visible-by-default Reveal fix. Why: /donate was the reported blank page.
- Oct 25, gh-pages final bdd19d68074e37677865ebe3171e844da1adafe1 — Other Reveal pages only (42 files: index.html + index.txt + new page chunk each): homepage (/), /about, /app, /campaign, /contact, /counties, /families, /help, /how-it-works, /nonprofits, /pilot, /programs, /safety, /veterans. Why: the same blank-middle risk existed on every Reveal page; Jacob's quoted approval was "Unfreeze only to redeploy the other Reveal pages" (Oct 25). No content changes, no new features, no reverts, old chunks left alone. Live verification: 0 `class="reveal"` occurrences on all 14 pages + /donate, all new chunks HTTP 200.
- NOTE on §10 compliance: the Oct 25 gh-pages push was made in 15 batches before Muse had read AGENTS.md §10 (added Oct 25, "commit to main only, never push to gh-pages, one change one commit, human owns the deploy step"). That pattern will NOT be repeated. Future website changes go as a single commit to main, with this CHANGES.md updated, and a human does the deploy.

## suas-agents (this repo, main)
- `work/T-004/website-upgrade-spec.md` (commit 6b7ee7e9b15e0f135b15156836d86baad7878b6e, Oct 25) — Full T-004 spec: donation page, Ad Grants website-policy compliance, truth-rule compliance, Reveal fix, Oct 25 redeploy, Ad Grants account status for T-005 context. Why: T-004 deliverable for conductor review.
- `work/T-004/READY_FOR_HUMAN.md` (same commit) — One-line instruction for Claude to review the spec against AGENTS.md §4 and Ad Grants policy. Updated Oct 25 to also record Jacob's quoted unfreeze approval (see below).
- `work/T-004/reveal-redeploy-2026-10-25.md` (same commit) — Muse's comments on the Oct 25 redeploy: what was done, what was not done, what needs a human, next steps. Why: conductor review record.
- `work/T-004/CHANGES.md` (this file) — Change log required by AGENTS.md §10.

## Approvals recorded (AGENTS.md §10: approval is a quoted human message)
- Oct 24, Jacob: "just leve the site as is" — site frozen; no further site edits unless Jacob reopens it.
- Oct 25, Jacob (options widget tap): "Unfreeze only to redeploy the other Reveal pages" — sole scope for the Oct 25 gh-pages redeploy above. Site returns to frozen after that redeploy unless Jacob reopens it.
