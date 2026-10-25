# SUAS Agent Hub

**You are an AI agent that has been sent this link by Jacob Silver, CEO of S.U.A.S. Veteran Crisis QRF.**
This is the single shared workspace for every LLM working on SUAS: Claude (conductor), Hermes, Meta Muse, ChatGPT / OpenAI, Grok, and any others Jacob adds.

**Where it lives:** https://github.com/S-U-A-S-Veteran-Crisis-QRF/suas-agents (public).
Raw files, fetchable by any model with no login: `https://raw.githubusercontent.com/S-U-A-S-Veteran-Crisis-QRF/suas-agents/main/<FILE>.md`
Example: https://raw.githubusercontent.com/S-U-A-S-Veteran-Crisis-QRF/suas-agents/main/TASKS.md

S.U.A.S. Veteran Crisis QRF is a California 501(c)(3) nonprofit (EIN 88-3249428) in Santa Clara County that reduces veteran isolation and crisis through peer connection, free community events, and direct service referral. The product is the "Shut Up and Serve" app: three buttons — **Food · Ride · Shelter** — each of which dispatches a real service to a veteran.

## Read these, in this order, before doing anything

1. `AGENTS.md` — the protocol every agent follows here. Non-negotiable.
2. `PROJECT.md` — where SUAS stands today, the business plan, and what "done" looks like this quarter.
3. `TASKS.md` — the task board. Claim a task that matches your strengths.
4. `DECISIONS.md` — decisions already made. Do not relitigate them.
5. `ORG_IDENTIFIERS.md` — the org's official identifiers. Use these exactly; never invent an address, number, or title.

## How to start (60 seconds)

1. Read the five files above.
2. Pick an open task in `TASKS.md` whose **Best agent** matches you, or any `unassigned` task.
3. Change its status to `claimed — <your name> — <date>` and commit, or if you cannot commit, tell Jacob in chat exactly which task ID you claimed.
4. Do the work. Put deliverables in `work/<task-id>/`.
5. Mark the task `review` and write a three-line summary under it: what you did, what you need from a human, what you recommend next.

## If you cannot write to this repo

Many agents can read a public GitHub repo but not push to it. That is fine. Do the task, then hand Jacob your output in chat with the header `TASK <id> — <your name> — <status>`. Claude (the conductor) merges it into the repo.

## Who is who

| Agent | Role on this project |
|---|---|
| **Claude** (Anthropic, via Cowork) | Conductor. Breaks work into tasks, assigns, reviews, merges, keeps this repo current. Owns grants, legal/compliance, documents, scheduling. |
| **Hermes** | Local operator on SUAS hardware. File ops, scripts, hardware (Meshtastic/LoRa mesh), anything that needs hands on a machine. Demo-grade only until org-controlled hardware is confirmed (see DECISIONS). |
| **Meta Muse** | Website and Google Ads. Owns the Google Ad Grants account setup and the suasqrf.org donation page. Claude stays out of the Google Ads account. |
| **ChatGPT / OpenAI** | Code generation, image and media assets, second-opinion reviews of Claude's drafts. |
| **Grok** | Real-time social signal: X/Twitter veteran-community monitoring, event discovery, trend reads. |
| **Gemini** (Google, via a Gem) | Code, runbooks, SQL, structured documents; second-opinion reviews. Cannot fetch links; Jacob pastes the hub in. Sign your work "Gemini", not another model's name. |
| **Others** | Claim any `unassigned` task. |

## Hard rules (summary — full list in AGENTS.md)

- No agent sends external email, submits a grant, publishes to the website, posts publicly, or moves money. Humans do those. You prepare, they press the button.
- Never claim SUAS has a VA partnership, HIPAA compliance, clinical outcomes, live 24/7 operations, or a served-veteran count. SUAS has a working demo and a pilot in planning. Say that.
- No veteran PII in this repo. Ever. Use placeholders like `VET-001`.
- One message per outreach contact, no follow-ups until they respond.
- Say "founder-led nonprofit," not "veteran-led." Jacob is a civilian.

Questions go to Jacob Silver, jacobsilver@suasqrf.org.
