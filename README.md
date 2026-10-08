# llm-profile

Personal instructions for LLMs: who I am, how I work, and how I want assistants to respond. The files are written for the model; this README is for people.

| File | Used by |
|---|---|
| `core.md` | Everything |
| `chat.md` | Chat surfaces: claude.ai preferences, Open WebUI |
| `agent.md` | Coding agents: Claude Code, opencode |
| `gateway.md` | Coding agents on hosts that can reach the MCP gateway: tools and memory |
| `bundles.json` | Which files form each bundle: `chat`, `agent`, `agent-standalone` |
| `skills/` | Agent skills, deployed to `~/.claude/skills/` |

The rc repo assembles and deploys the bundles. For claude.ai, paste the chat bundle into Settings → Instructions for Claude:

```sh
jq -r '.chat[]' bundles.json | xargs cat | pbcopy
```

Agents don't change these files on their own authority: they propose rule changes as PRs here, one rule per PR, and nothing lands without review (see `CLAUDE.md`). Sessions that can't open a PR leave a note in Basic Memory for a later session to turn into one. CI checks that each bundle stays under its word budget.

## Releases

Every push to `main` that changes the bundles or skills publishes a release. The latest chat bundle is always at https://github.com/stackptr/llm-profile/releases/latest/download/instructions-for-claude.md.
