---
name: propose-rule
description: Propose a change to the user's global instructions (the llm-profile repo) through a reviewable PR instead of editing them silently. Use when the user corrects a behavior that should persist across all repos and sessions, states a lasting preference ("from now on…", "always…", "don't…"), or a global instruction proves wrong or outdated, even if they don't ask for it to be saved. Not for project instructions (a repo's CLAUDE.md or AGENTS.md): edit those directly, following that repo's conventions.
---

# Proposing a rule

Global instructions live in the llm-profile repo (github.com/stackptr/llm-profile), and every change reaches them through a PR the user approves.

This skill is only for those global instructions. If the rule only matters in one repository, it belongs in that repo's own instructions (CLAUDE.md, AGENTS.md, or similar): edit them directly, following that repo's commit conventions, and stop here.

## Opening a PR against llm-profile

1. Check for an existing proposal: `gh pr list --repo stackptr/llm-profile --state open`. If an open PR covers the same behavior, push to its branch and comment instead of opening another.
2. Clone into a scratch directory: `gh repo clone stackptr/llm-profile "$(mktemp -d)/llm-profile"`. Read its CLAUDE.md first and follow its writing rules; it won't load automatically because the clone sits outside your working directory.
3. Make the smallest change that captures the rule, in the narrowest file it applies to (`core.md`, `chat.md`, `agent.md`, or a skill). One rule per PR, so each can be accepted or rejected on its own.
4. Commit and push using the git rules in your instructions (unsigned, with a `Co-Authored-By:` trailer). Branch: `feat-<slug>` for a new rule, `fix-<slug>` for correcting one.
5. Open the PR with `gh pr create --repo stackptr/llm-profile`, titled `feat: <rule in a few words>` or `fix: …`, with this body:

```markdown
## Why
<What went wrong, or what the user said, in a sentence or two.>

## Evidence
<The correction or situation that prompted this, described generically.>

## Conflicts
<Existing instructions this changes or contradicts, or "none known".>
```

6. Tell the user in one line that you opened a proposal PR, with its link. Don't merge it.

llm-profile is public. Keep the PR free of anything private: no employer names or details, proprietary code, hostnames beyond those already in the repo, or personal information the user hasn't already published there. Describe the evidence in general terms.

## When you can't open a PR

If `gh` isn't authenticated for llm-profile, or you're in a sandbox without access to it, write a note to Basic Memory (project "main") in `rule-proposals/` instead: title `YYYY-MM-DD short-slug`, tag `rule-proposal`, with the proposed text, the target file, and the Why/Evidence/Conflicts sections above. A later session will turn it into a PR. If Basic Memory isn't available either, end your reply with the proposed text, its target file, and those three sections, so the user can file it. Tell the user which route you took.
