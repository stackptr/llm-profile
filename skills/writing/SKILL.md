---
name: writing
description: Check and revise prose that other people will read so it doesn't read as machine-written. Use after drafting a PR description, commit message, README, doc, design note, or blog draft, before posting or committing it.
---

# Revising prose

Write the draft first, then check it against the lists below and revise. The goal is writing that reads like a competent engineer typed it. When a rule collides with being clear, be clear.

This applies to running prose: PR descriptions, commit messages, docs, code comments, design notes. Reference material that is genuinely structured (tables, steps, comparisons) can stay structured.

## Words to replace

These are the loudest signals of machine-written text. Replace each with the plain word or cut the sentence, unless it's the precise technical term: delve, tapestry, meticulous, pivotal, intricate, interplay, underscore, garner, bolster, vibrant, bustling, multifaceted, seamless, commendable, ever-evolving, realm, landscape (figurative), testament, showcase, foster, harness (verb), unlock (figurative), elevate, embark, navigate (figurative), robust, crucial, essential, profound, nuanced, holistic, myriad, plethora, leverage (verb).

Connective openers usually add nothing: "Additionally", "Moreover", "Furthermore", "In conclusion", "Overall", and "That said" at the start of a paragraph. Check whether the sentence works without them.

## Constructions to rewrite

- Negative parallelism: "not just X, but Y", "not only X but also Y", "it isn't X, it's Y". Say the true thing and stop.
- "No X, no Y" chains: "no config, no setup, no hassle".
- Didactic hedging: "it's important to note that", "it's worth noting", "keep in mind that". If it matters, state it; if not, cut it.
- Puffery and significance inflation: "stands as a testament to", "plays a crucial role in", "marks a pivotal moment", "rich history", "boasts".
- Participle tails: a sentence ending in ", highlighting…", ", underscoring…", ", showcasing…", ", reflecting…", ", demonstrating…". That clause is commentary; cut it or make it a claim with support.
- Vague attribution: "experts argue", "studies show", "industry reports indicate". Cite a specific source or drop the claim.
- Challenges-and-outlook boilerplate: "despite these challenges", "challenges remain", "it remains to be seen".
- Stage-managed reveals: "here's the thing", "here's the catch", "turns out…", "the punchline is".
- Performative honesty: "to be honest", "let me be clear", "honestly,". Be honest without announcing it.
- Therapy voice: "sit with that", "that's not nothing", "worth naming", "that's valid".
- Superlative narrowing: "that's the whole point", "the only X I trust", "that's the part that matters".
- Dev-blog boilerplate: "it just works", "batteries included", "zero config", "sane defaults", "first-class citizen", "game changer", "under the hood".
- Rhetorical question stacks: two or more questions in a row that you then answer yourself.
- Repeated sentence frames: consecutive sentences on the same skeleton, or three sentences in a row starting with the same word.
- Rule of three: a list padded to three items for rhythm. Two items is fine, and so is four.
- Colon into a triple: "the fix touches three things: parsing, caching, and retries", when the sentence works without the colon.

## Formatting

- No emoji unless the reader used one first.
- Bold only for a genuine label, and rarely.
- Sentence case for headings.
- Straight quotes and apostrophes, not curly ones.
- Em dashes are fine, at most one per paragraph.
- Don't break an argument into bullets of noun phrases; keep it as prose.
- No opening that restates the request and no closing paragraph that restates the body.

## What to aim for

Short declarative sentences. Concrete nouns and specific numbers. Say what happened and what it means for the reader. When you're uncertain, say what you don't know rather than smoothing it over.

## Credit

Adapted from the `writingStyle` section of fzakaria/nix-home (MIT; see LICENSE in this directory), which draws on Wikipedia's "Signs of AI writing" and Simon Willison's LLM cliché highlighter.
