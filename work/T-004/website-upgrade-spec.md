# T-004 — Website upgrade spec + donation page (Meta Muse)

Author: Meta Muse. Date: 2026-10-25. Repo: S-U-A-S-Veteran-Crisis-QRF/suas-webapp (source main, live site from gh-pages). Status in TASKS.md: review — Meta Muse — 2026-10-24.

## What the site is
- Public name: SUAS QRF. Legal name: S.U.A.S. Veteran Crisis QRF. EIN 88-3249428. California 501(c)(3), effective July 8, 2022. Address: 727 Edge Lane, Los Altos, CA 94024. Phone: 925-727-6109. Website: https://suasqrf.org.
- Next.js App Router, static export, GitHub Pages. Source main at 030a812 (Oct 24, 2026) plus the Oct 25 gh-pages redeploy below; no source changes were made Oct 25.
- Founder-led nonprofit. Jacob Silver is a civilian founder, not a veteran. Do not describe him as a veteran, and do not use "veteran-led" for him personally.

## Donation page (live, verified Oct 24)
- Route: /donate. Hero (Hacker Dojo hackathon group photo), tiers $25 meal / $150 shelter night / $210 full bundle, with a monthly toggle (Monthly pre-selected), property-gift section including The Landing, honesty block, inquiry form, 7 FAQs, 988 band, EIN footer.
- Workplace-giving line, under the tax-deductible/EIN/IRS-letter note, links "Find SUAS QRF (EIN 88-3249428) in your workplace giving portal" to the public Benevity profile https://causes.benevity.org/causes/840-883249428 (new tab). The word "Benevity" does not appear in the visible link text.
- Primary donation rails are GoFundMe and PayPal Giving Fund, linked out deliberately; no native embedded donate form, no payment details entered anywhere by Muse.

## Ad Grants website-policy compliance (as built)
- EIN, 501(c)(3) status, address, phone, and 988 non-emergency framing are visible site-wide (footer + /donate).
- /help landing page is live. All site images are WebP (OG.jpg kept). Full NGO JSON-LD is present. GA4 tag G-2GJCV5XX5B and Google Ads tag AW-18532521945 are installed site-wide.
- No policy disapprovals were found in the Oct 25 Ad Grants check. The remaining Ad Grants issues are account-side, not site-side: keyword volume and a goal diagnostic (see below), not a website-policy block.

## Truth rules (AGENTS.md §4) — how this spec complies
- Stage is described as working demo, pilot in planning, not live. No claim of: VA partnership, HIPAA compliance, clinical outcomes, live 24/7 service, named partners without written consent, or any served-veteran count.
- Hackathon win may be cited: Veterans Innovation Hackathon, Hacker Dojo, Aug 28–30, 2026.
- SUAS files IRS Form 990-N (gross receipts under $50k). Funders requiring a filed 990/990-EZ or a revenue minimum are out of scope.
- No bracket placeholders. All identifiers above are from ORG_IDENTIFIERS.md and verified public records.

## Reveal blank-middle fix — root cause and fix (Oct 24, completed for /donate; Oct 25, completed for all other Reveal pages)
- Root cause: components/Reveal.tsx + app/globals.css — `.reveal{opacity:0}` and only JavaScript IntersectionObserver adding `.in` could show content. Almost every middle section of Reveal pages was Reveal-wrapped, so any JS/observer/chunk failure left header/hero + footer visible and the middle blank.
- Fix (source main, commit f650959): server render carries NO `reveal` class at all, so content is visible even with no JavaScript; the reveal class is only added after JS mounts; in-view sections show immediately, below-fold sections fade on intersection, with a 1s fallback timer and a noscript style retained.
- Full handoff note for the next agent: docs/donate-reveal-blank-fix-2026-10-24.md in suas-webapp main (commit 030a812).

## Oct 25 redeploy — other Reveal pages (Jacob: "Unfreeze only to redeploy the other Reveal pages")
- Scope was ONLY this redeploy. No content changes, no new features, no reverts, no source changes. Old built chunks were left alone (content-hashed chunks are immutable; if a hash already exists on gh-pages, it was skipped).
- Pages redeployed to gh-pages (index.html + index.txt + new page chunk each, 42 files, 15 batches, final gh-pages commit bdd19d68074e37677865ebe3171e844da1adafe1):
  homepage (/), /about, /app, /campaign, /contact, /counties, /families, /help, /how-it-works, /nonprofits, /pilot, /programs, /safety, /veterans.
- Pages NOT redeployed (do not use Reveal): /privacy, /transparency, /not-found. /donate was already redeployed Oct 24 (final gh-pages commit f7471da, chunk page-c8c80093ff9eb60f.js).
- Live verification Oct 25 (cache-busting ?v=revealredeploy25, trailing-slash URLs): all 14 redeployed pages + /donate show 0 occurrences of `class="reveal"` in server HTML, and all new page chunks return HTTP 200.
- Site status after this redeploy: return to frozen unless Jacob reopens it. Do not make further site edits on the basis of this spec alone.

## Ad Grants account status (for T-005 context, not part of this spec's site work)
- Account: S.U.A.S. Veteran crisis QRF, Customer ID 464-175-8535, timezone Eastern (GMT-04:00), active since Oct 23, 2026. Three campaigns, $329/day total: Donations $179/day (US targeting), Get Help $120/day (Santa Clara County only), Brand $30/day (US targeting).
- Oct 24 full day + Oct 25 morning: 0 impressions, 0 clicks, $0.00 spend, 0 conversions, account-wide. No policy disapprovals.
- Call/Messaging Ads terms: ACCEPTED Oct 25, 2026 (Click-to-Call + Lead form ads, both verified Accepted after reload; call asset 925-727-6109 now editable, asset itself unchanged).
- Still open, account-side: (1) "missing a primary conversion action" diagnostic persists on Donations + Brand despite the Oct 24 settings fix; (2) Brand's new ad group keywords are all "Low search volume"; (3) keyword widening + goal-wiring fix was offered Oct 25 and not yet approved. These are T-005 follow-ups, not site edits.
