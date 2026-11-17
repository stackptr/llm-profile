---
name: orchestrate
description: Coordinate a multi-PR implementation plan from one T3 Code thread. Launch a thread per sub-task, stack dependent work, track status, and give each PR a bounded review window. Use when the user asks you to orchestrate or coordinate a plan across T3 threads, or to act as coordinator.
argument-hint: "[plan doc]"
---

# Orchestrating a plan in T3 Code

You're the coordinator: you don't write code. Each sub-task gets its own thread, worktree, and PRs, and you track them.

## How T3 behaves

- No tool forks a thread. `t3_thread_launch` starts a new one that knows only what its first message says.
- A launched thread doesn't wake the thread that launched it. Children report back with `t3_thread_send`, or the plan stalls until the user next asks.
- A PR watch wakes its thread only on PR events (checks, comments, pushes), never on a timer. A thread shows as "Working" while it runs or holds a watch, so every watch needs an end condition.
- Agent `gh` actions post under the user's GitHub account, so an agent's comments look human unless they're marked.

## Setup

1. Confirm the T3 project's root is the repo the PRs go to. If it isn't (a meta-repo, say), create a project for that repo, or worktree handoffs will branch the wrong repo.
2. Keep a tracker table in the plan doc: sub-task, thread link, branch, PR(s), state. The doc survives context compaction. On a status request, rebuild it from `t3_thread_list` and `gh`, not memory. While doing that, unwatch any PR whose review window has passed.
3. Before writing briefs:
   - list the default branch's required checks, and any check that fails on every PR;
   - verify each code claim a brief makes against the current default branch.

## Launching

- For each sub-task with no unmet dependency, call `t3_thread_launch` in that project:
  - set `delegatedFrom` to your thread;
  - title it `<ticket>: <sub-task>`;
  - give it a self-contained brief.
- The brief's first step is `t3_worktree_handoff` to the sub-task's branch. Its base is the default branch, or the parent branch for stacked work.
- Launch a dependent sub-task once its base branch is pushed, stacked on it. If the base sub-task split into several stacked PRs, stack on the top one.
- Run at most three threads that are still implementing. A thread in its review window doesn't count.
- Mark answers to open questions as provisional in briefs. When the user decides differently, relay it to the affected threads.
- When a child escalates a human review comment, show it to the user with the child's suggested reply and proposed change, then relay the decision. Never reply to a human reviewer yourself.

## What every brief requires of the child

1. Open each PR as a draft. The body says what changed, what to verify, and where the PR sits in the stack.
2. End every PR comment and review reply it posts with the line `🤖 Agent comment via orchestration session`. Bare bot commands such as `/review` are the only exception.
3. Link and watch each PR. During the review window:
   - fix failing required checks;
   - reply to or fix automated review findings, with fixes pushed as new commits.

   If no bot review has arrived about 15 minutes after opening, comment `/review` once.
4. Call `unwatch_pull_request` at the first wake where either:
   - required checks have finished on the latest head, and every bot finding has a reply or fix; or
   - 60 minutes have passed since the PR opened.
5. A comment is human if it isn't from a bot, lacks the trailer, and isn't a bare bot command. A bot's reply inside a human's thread is part of that thread. On a human comment:
   - never reply on the PR;
   - send the coordinator the link, a quote, a suggested reply, and whether a code change is needed, with a short description of it;
   - push that change only after the user approves it, and report the new head SHA. The user posts any reply.
6. Message the coordinator with `t3_thread_send` when:
   - the branch is first pushed;
   - the PRs are open;
   - a human comment needs escalating;
   - it hits a blocker, or the code contradicts the brief;
   - the review window ends.

   End the final message with `PR <URL>, head <SHA>, checks and reviews <state>`.
7. Never mark a PR ready for review, merge, close, or force-push. If the base branch changes, merge it in rather than rebasing.

After a base PR merges, restack its dependents only when the user asks.
