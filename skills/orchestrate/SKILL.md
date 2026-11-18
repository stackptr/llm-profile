---
name: orchestrate
description: Coordinate a multi-PR implementation plan from one T3 Code thread. Launch a thread per sub-task, stack dependent work, track status, and give each PR a bounded review window. Use when the user asks you to orchestrate or coordinate a plan across T3 threads, or to act as coordinator. In T3 Code, when work splits into independent sub-tasks or a tangent would pull the thread off its task, offer to run it this way or as its own thread.
argument-hint: "[plan doc]"
---

# Orchestrating a plan in T3 Code

You're the coordinator: you don't write code. Each sub-task gets its own thread, worktree, and PRs, and you track them.

## How T3 behaves

- Most T3 tools are deferred: load them by exact name with ToolSearch (`select:mcp__t3-code__<tool>`). `orchestrator_capabilities` lists models, not tools.
- `t3_thread_launch` starts a thread that knows only its first message. `t3_thread_transfer` with `action: "fork"` copies this thread's context into a new one instead, but only up to a finished turn: it can't fork the turn that's running.
- A launched thread doesn't wake the thread that launched it, even with `delegatedFrom` set. Children report back with `t3_thread_send`, or the plan stalls until the user next asks.
- A PR watch wakes its thread only on PR events (checks, comments, pushes), never on a timer, so a time limit is only checked at the next wake. A thread shows as "Working" while it runs or holds a watch, so every watch needs an end condition.
- Agent `gh` actions post under the user's GitHub account, so an agent's comments look human unless they're marked.
- Processes a child starts (a test database, a dev server) outlive its turn and its thread.
- T3 doesn't know PRs are stacked when they live in different threads. The tracker is the only record of the stack.
- Claude Code's own permission rules still apply under T3's full-access mode, so a command matching an ask rule (such as `gh api` with `-X` or `-F`) waits for approval that nobody gives in an unattended run.

## Setup

1. Confirm the T3 project's root is the repo the PRs go to. If it isn't (a meta-repo, say), create a project for that repo, or the worktrees will branch the wrong repo.
2. Write your own thread ID and title (`currentThreadId` from `t3_thread_list`) into the plan doc. Children need the ID to report back, and compaction can drop it.
3. Keep a tracker table in the plan doc: sub-task, model, thread link, branch, base, PR(s), state. The doc survives compaction. On a status request, rebuild it from `t3_thread_list` and `gh`, not memory. While doing that, check each child's watches with `list_thread_pull_requests` (its `watching` field) and unwatch any PR whose review window has passed.
4. Before writing briefs:
   - list the default branch's required checks, and any check that fails on every PR. If the branch isn't protected, the API reports none: take them from the repo's docs;
   - verify each code claim a brief makes against the current default branch.

## Launching

- For each sub-task with no unmet dependency, call `t3_thread_launch` in that project:
  - `workspaceStrategy: {type: "worktree", branch, baseRef}`, so the thread starts in its own worktree. `baseRef` is the default branch with `startFromOrigin: true`, or the parent branch with `startFromOrigin: false` for stacked work;
  - set `delegatedFrom` to your thread;
  - title it `<ticket>: <sub-task>`;
  - give it a self-contained brief that includes your thread ID;
  - when passing `modelSelection`, pass `options` too, with your own effort level (from `t3_thread_configure`), or the child falls back to the provider's default.
- Children run on Opus. Propose Sonnet only for a sub-task the brief fully specifies, with no design choices and only a few files: tests for behavior the brief describes, a rename or move, config or docs, a version bump. Show each sub-task's model in the tracker before launching, so the user can change it. If a Sonnet child reports a blocker that needs judgment, offer to switch it to Opus with `t3_thread_configure`.
- When a sub-task depends on nuance from the investigation that a brief can't carry, fork instead: `t3_thread_transfer` `fork`, then send the fork its assignment. Forking needs a finished turn, so orchestrate in the turn after the investigation; if this is your first turn, queue a message to your own thread with `t3_thread_send` and fork in the turn it starts. A fork inherits your context, this skill and the user's orchestration request included, so its assignment opens by saying it's a sub-task, not the coordinator: it doesn't launch threads or edit the plan doc. A fork shares your checkout, so its first step is `t3_worktree_handoff` to its branch.
- Launch a dependent sub-task once its base branch is pushed, stacked on it. If the base sub-task split into several stacked PRs, stack on the top one. Tell the base's thread it has dependents, so it reports every later push; relay each one to the dependents, which merge the base in.
- Run at most three threads that are still implementing. A thread in its review window doesn't count.
- Mark answers to open questions as provisional in briefs. When the user decides differently, relay it to the affected threads.
- Never reply to a human reviewer yourself. The user handles human reviews in each PR's own thread.

## What every brief requires of the child

A repo's own instructions for PRs (drafts, auto-merge, titles, trailers) override these rules; say so in the brief.

1. Open each PR as a draft. The body says what changed, what to verify, and where the PR sits in the stack.
2. End every PR comment and review reply it posts with the line `🤖 Agent comment`. Bare bot commands such as `/review` are the only exception. Write PR bodies and comments with `--body-file`, and edit its own comment with `gh pr comment --edit-last`, not `gh api`, whose writes stop for approval.
3. Link and watch each PR. During the review window:
   - fix failing required checks;
   - reply to or fix automated review findings, with fixes pushed as new commits.

   If the repo's docs say how to request a bot review and none has arrived by the first wake after required checks finish, request it once.
4. Call `unwatch_pull_request` at the first wake where either:
   - required checks have finished on the latest head, and every bot finding has a reply or fix; or
   - 60 minutes have passed since the PR opened.
5. Leave human comments to the user, who works through them in this thread. A comment is human if it isn't from a bot, lacks the trailer, and isn't a bare bot command; a bot's reply inside a human's thread is part of that thread. Never reply to one on the PR, or change code for one unless the user asks in this thread.
6. Message the coordinator with `t3_thread_send`, `mode: "queue"` (the default steers a coordinator turn that's already running), when:
   - the branch is first pushed;
   - the PRs are open;
   - a human comment arrives during the review window;
   - it hits a blocker, or the code contradicts the brief;
   - the review window ends;
   - it pushes again while other sub-tasks are stacked on its branch.

   End the final message with `PR <URL>, head <SHA>, checks and reviews <state>`.
7. Stop any process it started, such as a test database or server, once it no longer needs it, and at the latest when its review window ends. Find the listener's PID with `lsof -iTCP -sTCP:LISTEN`, kill that PID (a package manager can run the server in a separate process group), and run `lsof` again to confirm.
8. Never mark a PR ready for review, merge, close, or force-push. If the base branch changes, merge it in rather than rebasing.

## Restacking

Only when the user asks, after a base PR merges: tell each dependent's thread to merge the default branch into its branch, resolve any conflicts, push, and confirm its PR now targets the default branch. GitHub retargets it when the merged base branch is deleted; if it didn't, the thread runs `gh pr edit --base`. You don't do the merge yourself.
