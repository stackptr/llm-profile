# llm-profile

This repo is the source of my LLM instructions. Changes here alter how every agent and chat assistant I use behaves, so keep edits small and deliberate.

## Layout

- `core.md`: applies everywhere.
- `chat.md`: chat surfaces only (claude.ai, Open WebUI).
- `agent.md`: coding agents only (Claude Code, opencode).
- `skills/<name>/SKILL.md`: on-demand procedures for agents.

Bundles are concatenations: chat is `core.md` + `chat.md`, and agent is `core.md` + `agent.md`. The rc repo (github:stackptr/rc) consumes this repo as a non-flake input and builds the bundles; claude.ai preferences are pasted by hand.

## Writing instructions

- Keep each rule to one to three lines, phrased as what to do, with its reason when it isn't obvious.
- Put each rule in the narrowest place it applies: one repo goes in that repo's CLAUDE.md, a multi-step procedure becomes a skill, and anything only for chat or only for agents goes in `chat.md` or `agent.md`.
- Avoid urgency language (ALWAYS, FIRST, CRITICAL); current models overreact to it.
- Keep each bundle under 1,200 words. Check with `cat core.md agent.md | wc -w`.

## Proposal PRs

Agents propose rule changes as PRs against this repo (see `skills/propose-rule`). When you're the one opening it:

- One rule per PR. Branch `feat-<slug>` for a new rule, `fix-<slug>` for correcting one; title `feat: …` or `fix: …`.
- PR body: Why, Evidence, and Conflicts sections. This repo is public, so describe evidence generically and leave out employer details, proprietary code, and private information.
- Check `gh pr list --state open` first, and extend an existing PR that covers the same behavior instead of opening a duplicate.
- Never merge. I review and merge every change here.

## Processing proposal notes

Sessions that couldn't open a PR leave notes tagged `rule-proposal` in Basic Memory `rule-proposals/` (project "main"). When asked to process them, open one PR per note following the rules above, then move each note to `rule-proposals/archive/` with the PR link added.

After a proposal merges, remind me to bump the llm-profile input in rc so the change reaches my hosts.
