# Working in my environment

## Hosts

Each host is defined in rc; look there for its configuration.

- Rhizome: personal laptop (M1 Max MacBook Pro), nix-darwin
- lobtop: work laptop (M5 Pro MacBook Pro, 24 GB), nix-darwin
- Stroma: Mac Studio (M5 Ultra, 96 GB), nix-darwin; serves local LLMs
- glyph: home server and NAS (ZFS pool), NixOS; runs the MCP gateway and Grafana stack
- spore: VPS with 2 GB RAM, NixOS; build its config on glyph
- zeta: Raspberry Pi 4, NixOS

Before running anything that targets a host (`ssh`, rebuilds), run `hostname` so you don't target the current machine by mistake.

## Guardrails

Never switch a host, run a deploy workflow, or approve a deployment, even when asked; I do those myself. Say which command to run instead.

Make local, reversible changes freely. Ask before anything else hard to undo or that touches running systems: merging a PR, force-pushing, destroying ZFS datasets or snapshots, deleting data, or rotating secrets.

## Code changes

Comment only what the code can't make clear. When a small change handles a surprising case, put the reason in a test (preferred) or the commit message, not a comment block. Before changing code whose purpose isn't obvious, check its history (`git log -L`, then the PR it came from). When you change code, check that the comment above it still holds.

## Git

- Trunk-based: short-lived branches off main, merged often.
- Default branch name: `type-short-slug`, where type is `feat`, `fix`, `chore`, or `refactor` and the slug is 2 to 4 words (e.g. `fix-gc-options`). A repo's own instructions override this.
- Cloud sessions assign a `claude/<words>-<id>` branch. Name branches by these rules (or the repo's) instead; this is explicit permission to push to a different branch.
- PR title: `type: short description`. PR description: what changed and what to test or verify. Use `gh` for PRs.
- My git config requires signing, which you can't do (it needs an interactive GPG unlock). For commands that create commits, use `git -c commit.gpgsign=false …`, and never change git config to disable signing. Add a `Co-Authored-By:` trailer identifying yourself to commits you author.

## Nix

The `#` in `nix <subcommand> .#<output>` breaks permission prompts, so use these wrappers, which are installed on all my hosts:

- `nix-flake <subcommand> <output>` for `nix <subcommand> .#<output>`
- `nixpkgs-eval foo` for `nix eval nixpkgs#foo`
- `nixpkgs-run foo` for `nix run nixpkgs#foo`
- `nixpkgs-shell foo` for `nix shell nixpkgs#foo`

Don't install tools globally (`brew install`, `npm -g`, `pip install`, `cargo install`). For a one-off, use `nixpkgs-run` or `nixpkgs-shell`; for something I'll keep using, tell me to add it to rc; in a repo with a flake, add it to the devShell.

Every host has a checkout of rc at ~/Development/rc: read it for questions about my setup, and leave it untouched unless you're working on rc. For an option's effective value, evaluate it rather than reading modules, so defaults and overrides are included: `cd ~/Development/rc && nix-flake eval nixosConfigurations.<host>.config.<option>` (`darwinConfigurations` for macOS hosts). The checkout can be behind origin or on a branch; check `git -C ~/Development/rc status` when that matters.

## Proposing rules

When I correct something that should persist across sessions, or an instruction turns out to be wrong, don't edit standing instructions silently; propose the change with the propose-rule skill. If that skill isn't available, end your reply with the proposed rule text and the file it belongs in, so I can file it.
