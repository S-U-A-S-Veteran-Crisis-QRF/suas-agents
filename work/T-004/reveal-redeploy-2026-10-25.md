# Muse comments — Reveal redeploy, Oct 25, 2026 (for Claude, conductor)

## What I did
- On Jacob's "Unfreeze only to redeploy the other Reveal pages" (Oct 25), I rebuilt suas-webapp from the clean main clone at 030a812 (no source changes) with NEXT_PUBLIC_GA_ID=G-2GJCV5XX5B, and pushed only the Reveal pages' index.html, index.txt, and new page chunk to gh-pages: homepage, /about, /app, /campaign, /contact, /counties, /families, /help, /how-it-works, /nonprofits, /pilot, /programs, /safety, /veterans. 42 files, 15 batches, final gh-pages commit bdd19d68074e37677865ebe3171e844da1adafe1. Old chunks left alone.
- Live verification (trailing-slash URLs, ?v=revealredeploy25): 0 `class="reveal"` occurrences on all 14 pages + /donate, and all new page chunks HTTP 200. An early check without trailing slashes showed 301 redirects and stale CDN 404s; that was a checking artifact, not a deploy failure — re-checking correctly cleared it.

## What I did NOT do
- No content changes, no new features, no reverts, no source edits. /privacy, /transparency, and /not-found were not redeployed (they do not use Reveal). The site returns to frozen unless Jacob reopens it.
- I did not commit to suas-webapp/agents/ — the hub moved to suas-agents, per T-000.

## Needs a human
- Jacob: add Muse's GitHub App to suas-agents (Settings → Integrations) so future work/T-004/ commits can go direct instead of through chat/Claude. Until then, this filing is delivered via the connector with Jacob's approval, and Claude merges from chat as before.
- Claude: check website-upgrade-spec.md against AGENTS.md §4 and Ad Grants policy, then close T-004 or return findings.

## Next
- T-005 follow-up (account-side, not site): keyword widening + goal-wiring fix for the persisting "missing primary conversion action" diagnostic on Donations + Brand, and Brand's low-search-volume keywords. Offered to Jacob Oct 25, awaiting his go. Do not bundle it into T-004.
- Ad Grants terms update for the record: Call/Messaging Ads terms accepted Oct 25 (both Click-to-Call and Lead form ads); call asset 925-727-6109 now editable, unchanged.
