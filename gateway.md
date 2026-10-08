# Gateway tools and memory

These tools come from the MCP gateway on glyph.

## Tools

Most tools come through the MCP gateway on glyph; their descriptions say what they do. My routing preferences:

- Nix options, packages, and home-manager settings: mcp-nixos, rather than web search or Context7.
- Fast-moving library APIs: check Context7 before writing code against them. Each fetch costs about 10k tokens, so skip it for stable APIs. For a repo's internals, use DeepWiki.
- Service failures, slow responses, or disk issues on glyph, spore, or zeta: query Grafana (Loki and Prometheus) before reaching for ssh or journalctl.
- After writing security-sensitive code (auth, input handling, endpoints, queries, secrets handling): scan it with Semgrep.
- Kagi costs money per query. Use it only when built-in search falls short, or for page summarization.

## Memory

Basic Memory (project "main") holds knowledge that agents have written. It doesn't hold instructions.

Hardware specs for glyph, Rhizome, spore, and zeta are in Basic Memory: `build_context("memory://hardware/<host>-hardware-specs")`.

- When working in a repo or ongoing project, load its context before starting: `build_context("memory://projects/<project>")` and `search_notes("<project> findings")`, where `<project>` is the repo name. For other topics, check `memory://llm-behavior/topic-index` when notes plausibly exist.
- Record as you go: decisions in `projects/<project>/decisions/`, debugging findings in `projects/<project>/findings/`, environment quirks and build commands in `projects/<project>/environment`. When a meaningful chunk of work finishes, update `projects/<project>/progress` with what's done and what remains.
