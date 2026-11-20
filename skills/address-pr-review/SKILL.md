---
name: address-pr-review
description: Work through the open review threads on one or more PRs. Fix and resolve bot findings, fix small, low-risk human requests and leave those threads for the user to resolve, and report the rest with a summary and a drafted reply. Use when the user asks to address, handle, or work through review comments or feedback on a PR.
argument-hint: "[#123 | #123 #456 | repo#123 owner/repo#456]"
allowed-tools: Bash(gh-review-reply-human *)
---

# Addressing PR review comments

## Which PRs

- No argument: the PRs this session created or pushed to. In T3 Code, `list_thread_pull_requests` lists them. If there are none, use the PR for the current branch (`gh pr view`), and stop if there isn't one.
- `#123`, or several: PRs in the current repo (`gh repo view --json nameWithOwner`).
- `repo#123`: a repo under the current repo's owner. `owner/repo#123` names it fully.

Skip PRs that are merged or closed, and say so in the summary.

## Gathering threads

List each PR's unresolved review threads with `gh-review-threads OWNER/REPO PR`. It prints a JSON array sorted by file and line; each thread has the `comment_id` the reply and resolve commands take, and its comments in order. A thread is from an agent if `started_by.bot` is true or its first comment ends with `🤖 Agent comment` (another agent posting as the user); otherwise it's from a human. A bot's reply inside a human's thread doesn't change that.

Read the code each comment points at on the PR's head, plus enough around it to judge the comment. Comments can be outdated: check whether a later commit already handled it.

## Assessing each thread

Decide whether it needs a code change, and write two things:

- A note for the user: what the change is in plain words, then its risk and size. For example: "Return an empty list instead of throwing when the account has no addresses. Low risk, single line change." Leave out file paths and anything obvious from reading the comment; the user can ask. If no change is needed, say why.
- A reply for the reviewer: plain, short, and in the voice of the PR's author. Say what changed (or why nothing did) without restating the comment. Name a function or module only when the reply would be ambiguous without it.

Rate risk by what could break, not by line count: a one-line change to auth, billing, migrations, concurrency, or a public API is high risk. A large change is one spanning several files or changing behavior beyond what the comment asked.

## Acting

| Thread from | Assessment | Action |
|---|---|---|
| Agent | Code change | Fix, reply, resolve |
| Agent | No change | Reply with the reason, resolve |
| Human | Change that is low or medium risk and small | Fix, reply; leave open for the user to resolve |
| Human | High risk, large, a question, disagreement, or anything you're unsure about | Leave it; report the note and drafted reply |

When the agent's finding is wrong, say so in the reply rather than making the change to close the thread.

To fix:

1. Work on the PR's head branch, in this checkout if it's already on that branch and clean, otherwise in a worktree. For another repo, look for a checkout under `~/Development`; if there isn't one, report the thread instead of fixing it.
2. Make one commit per thread, following the repo's commit conventions, and run the checks the repo's docs name (tests, lint, typecheck) for what changed.
3. Push once per PR, after all its fixes. If the push is rejected because the branch moved, merge the remote branch in and push again; never force-push.

Then reply and resolve, after the push so the reply describes code the reviewer can see:

- `gh-review-reply OWNER/REPO PR COMMENT_ID` with the reply on stdin. It appends the `🤖 Agent comment` trailer.
- `gh-resolve-thread OWNER/REPO PR COMMENT_ID`.

Both refuse threads a human started. For a human thread you fixed, reply with `gh-review-reply-human`, which takes the same arguments, and never resolve it: the user resolves human threads.

## Summary

End with a short report, grouped by PR:

- Done: one line per thread handled, with its note and a link to the reply.
- Needs you:
  - human threads you fixed and replied to, for the user to check and resolve, with the note and a link to the reply;
  - human threads you left alone, with the note, the drafted reply, and what you'd need decided to proceed.
- Anything skipped: closed PRs, missing checkouts, failed checks, rejected pushes.
