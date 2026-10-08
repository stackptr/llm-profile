# Working in my environment

## Hosts

All hosts are configured in github.com/stackptr/rc. Hardware specs for glyph, Rhizome, spore, and zeta are in Basic Memory: `build_context("memory://hardware/<host>-hardware-specs")`.

| Host | Role | OS |
|---|---|---|
| Rhizome | Personal laptop (M1 Max MacBook Pro) | nix-darwin |
| lobtop | Work laptop (M5 Pro MacBook Pro, 24 GB) | nix-darwin |
| Stroma | Mac Studio (M5 Ultra, 96 GB); serves local LLMs | nix-darwin |
| glyph | Home server and NAS (ZFS pool); runs the MCP gateway and Grafana stack | NixOS |
| spore | VPS with 2 GB RAM; build its config on glyph | NixOS |
| zeta | Raspberry Pi 4 | NixOS |

Before running anything that targets a host (`ssh`, rebuilds), run `hostname` so you don't target the current machine by mistake.

## Guardrails

Make local, reversible changes freely. Ask before anything hard to undo or that touches running systems: switching or deploying a host config, merging a PR, triggering a deploy workflow, force-pushing, destroying ZFS datasets or snapshots, deleting data, or rotating secrets.

## Git

- Trunk-based: short-lived branches off main, merged often.
- Default branch name: `type-short-slug`, where type is `feat`, `fix`, `chore`, or `refactor` and the slug is 2 to 4 words (e.g. `fix-gc-options`). A repo's own instructions override this.
- PR title: `type: short description`. PR description: what changed and what to test or verify. Use `gh` for PRs.
- My git config requires signing, which you can't do (it needs an interactive GPG unlock). For commands that create commits, use `git -c commit.gpgsign=false …`, and never change git config to disable signing. Add a `Co-Authored-By:` trailer identifying yourself to commits you author.

## Nix

The `#` in `nix <subcommand> .#<output>` breaks permission prompts, so use these wrappers, which are installed on all my hosts:

| Instead of | Use |
|---|---|
| `nix <subcommand> .#<output>` | `nix-flake <subcommand> <output>` |
| `nix eval nixpkgs#foo` | `nixpkgs-eval foo` |
| `nix run nixpkgs#foo` | `nixpkgs-run foo` |
| `nix shell nixpkgs#foo` | `nixpkgs-shell foo` |

## Tools

Most tools come through the MCP gateway on glyph; their descriptions say what they do. My routing preferences:

- Nix options, packages, and home-manager settings: mcp-nixos, rather than web search or Context7.
- Fast-moving library APIs: check Context7 before writing code against them. Each fetch costs about 10k tokens, so skip it for stable APIs. For a repo's internals, use DeepWiki.
- Service failures, slow responses, or disk issues on glyph, spore, or zeta: query Grafana (Loki and Prometheus) before reaching for ssh or journalctl.
- After writing security-sensitive code (auth, input handling, endpoints, queries, secrets handling): scan it with Semgrep.
- Kagi costs money per query. Use it only when built-in search falls short, or for page summarization.

## Memory

Basic Memory (project "main") holds knowledge that agents have written. It doesn't hold instructions.

- When working in a repo or ongoing project, load its context before starting: `build_context("memory://projects/<project>")` and `search_notes("<project> findings")`, where `<project>` is the repo name. For other topics, check `memory://llm-behavior/topic-index` when notes plausibly exist.
- Record as you go: decisions in `projects/<project>/decisions/`, debugging findings in `projects/<project>/findings/`, environment quirks and build commands in `projects/<project>/environment`. When a meaningful chunk of work finishes, update `projects/<project>/progress` with what's done and what remains.
- When I correct something that should persist across sessions, or an instruction turns out to be wrong, don't edit standing instructions silently; propose the change as a PR using the propose-rule skill. If skills aren't available: for a repo-only rule, edit that repo's CLAUDE.md in the PR you're preparing; otherwise open a PR against stackptr/llm-profile that follows its CLAUDE.md, keeping it free of private details since the repo is public.
