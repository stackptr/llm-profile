# Working in my environment

## Hosts

All hosts are configured in github.com/stackptr/rc.

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

## Proposing rules

When I correct something that should persist across sessions, or an instruction turns out to be wrong, don't edit standing instructions silently; propose the change with the propose-rule skill. If that skill isn't available, end your reply with the proposed rule text and the file it belongs in, so I can file it.
