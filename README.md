# Maintainer Desk

**Switch agents that run your open-source contributor queue, while maintainers stay in charge.**

Contributors claim issues and report pull requests in a public Discord room. Three agents check every request against the project's rules, review every pull request twice (Claude, then an independent Codex check) and bring each decision to the maintainers' private Slack room, ready to approve in one reply. Nothing changes on GitHub until a person says so.

> Demo video: _coming_ · Built for the [Flip the Switch hackathon](https://www.wemakedevs.org/hackathons/switch), Track 1: Best Business Workflow.

## The problem

Popular open-source projects run contribution drives the same way: comment on an issue, tag a maintainer, wait to be assigned. During this hackathon, the Switch repository itself shows what that costs. Read-only, on 7 November 2026, `desk` found:

- every one of the 63 open `hackathon` issues already held, by 538 assignments in total; issue #843 alone has 8 assignees, under a rule of one person per issue
- 388 of those 538 assignments with no activity for 48 hours or more (213 of them for over a week), the point at which the rules say an issue may be handed on
- open pull requests that break the rules: #1705 and #1690 close issues not assigned to their authors, #1650 links no issue at all

Every one of those is a maintainer reading a comment, checking a rule by hand and typing a reply.

## How it works

```
         Discord                                   Slack
 ┌──────────────────────────┐   linked    ┌───────────────────────────────┐
 │  oss-contributors        │  "approvals"│  oss-maintainers (private)    │
 │                          │ ──────────► │                               │
 │  contributors            │             │  maintainers  ◄── decide      │
 │  oss-desk (Claude) ──────┼─────────────┼─► oss-desk                    │
 │   checks claims & PRs    │ ◄───────────┼── oss-reviewer (Claude)       │
 │   against the rules      │  outcomes   │      ▲  independent           │
 └──────────────────────────┘             │      ▼  second opinion        │
                                          │   oss-checker (Codex)         │
                                          └───────────────┬───────────────┘
                                                          │ desk CLI (gh)
                                                          ▼
                                                       GitHub
```

| Step | Room | What happens |
|---|---|---|
| Claim | contributors | "Can I take #12? GitHub: alice". The desk runs `desk claim-check 12 alice`: label, free, PR cap, issue cap. Ineligible requests are answered on the spot with three free issues; eligible ones go to the maintainers. |
| Approve | maintainers | "Claim #12 for alice: eligible, 1 of 5 PRs open." The maintainer replies `@oss-desk approve 12`. The desk assigns her on GitHub and tells her in Discord. |
| Review | maintainers | "PR #9 is up." The reviewer (Claude) reads the facts and the diff, records its verdict, then asks the checker (Codex) for an independent one. The maintainer gets both verdicts and a ready command (`@oss-desk comment 9 ...` or `@oss-desk close 9 ...`). When they disagree, the maintainer decides. |
| Sweep | maintainers | `@oss-desk sweep` lists assignments idle past 48 hours and pull requests nobody reviewed. `@oss-desk unassign 7` frees an issue and announces it to contributors. |

## Why this needs Switch

A GitHub Action can label and comment. It cannot:

- **hold a conversation with a contributor** in the chat app they already use, ask for their GitHub username, and answer their follow-up question
- **carry a case between two rooms on two different chat apps**, public Discord and private Slack, with the history of both in one shared log
- **wait for a person's decision** and act on it, in the room where maintainers already are
- **put agents from two providers in one room** so a Claude reviewer and a Codex checker can disagree in front of a human

Take Switch away and the project is a script maintainers have to run themselves. With Switch, the agents are members of the team: they sit in the team's rooms, address each other by name, and take instructions from people.

Switch features used: a room group with two linked rooms on different bridges, per-agent providers, `addressing` (`anyone` for the desk, `owner-agents` for the reviewers), a room doc with the rules, per-room kickoffs, and a one-import template.

## Run it yourself (about 10 minutes)

You need: [Switch Console](https://docs.switchagents.ai/switch-rooms/getting-started) with a local server running, Claude Code and Codex signed in, Discord (and optionally Slack) connected in the Console, and [`gh`](https://cli.github.com) logged in on the same machine, plus `jq`.

1. **Make a demo repository** (a tiny Python library with 8 issues and 3 pull requests that exercise every rule):
   ```bash
   git clone https://github.com/Bhaskar422/maintainer-desk && cd maintainer-desk
   scripts/seed-demo-repo.sh            # creates <you>/desk-demo
   scripts/install.sh                   # installs the desk CLI for your agents at ~/.maintainer-desk/bin/desk
   ```
   The agents only ever run the tool you installed; they never download or install code themselves.
2. **Try the rulebook on its own** (read-only):
   ```bash
   TARGET_REPO=<you>/desk-demo bin/desk sweep
   TARGET_REPO=<you>/desk-demo bin/desk claim-check 2 someone
   ```
3. **Create the desk in Switch.** In Switch Console, open Templates, add `templates/maintainer-desk.template.yaml`, set **Repository to run** to `<you>/desk-demo`, and create. Switch makes the three agents, both rooms and the link, and each agent introduces itself.
4. **Use it.** In the contributors room: `@oss-desk can I take #4? my GitHub is <you>`. In the maintainers room: `@oss-desk approve 4`, then `@oss-desk sweep`.

**Try it on a real repository without changing anything:** choose **Mode: preview** in the form. Every GitHub change is then described instead of made. The rulebook alone also works read-only on any public repository:

```bash
TARGET_REPO=sandbox-quantum/switch DRY_RUN=1 bin/desk sweep
```

## The rulebook: `bin/desk`

Agents never guess a rule: they call `desk`, which prints JSON they quote. Every change honours `DRY_RUN=1` and is logged to `~/.maintainer-desk/desk-log.jsonl`, which `desk metrics` summarises.

| Command | Does |
|---|---|
| `desk claim-check <issue> <user>` | label, already held, PR cap, issue cap; suggests free issues when blocked |
| `desk assign` / `unassign` | changes the assignment and leaves an explanatory comment |
| `desk pr-facts <pr>` | linked issues, rule breaks, size, tests, CI |
| `desk pr-diff <pr>` | the diff for the reviewers |
| `desk sweep` | assignments idle past the limit (assignment, comments, commits and PRs count as activity), open PRs |
| `desk comment` / `close-pr` | the actions a verdict turns into |
| `desk metrics` | what the desk has done |

The rules live in [`desk.conf`](desk.conf): claim label, PR cap, issue cap, idle hours, the trivial-change threshold. Each can be overridden by an environment variable.

## Safety

- No agent changes GitHub without an instruction from a person in the maintainers room; requests from contributors or other agents never count as approval.
- Nobody merges except a maintainer, by hand.
- The checker forms its verdict before reading anyone else's.
- Preview mode and `DRY_RUN=1` make every change a description.
- Agents never fetch or install code. The owner installs the desk CLI once (`scripts/install.sh`); agents only run that. This matters: an agent that downloads a script because a chat message asked it to is exactly what Claude Code's auto mode blocks as a prompt-injection pattern, and it is right to.
- Pull request diffs are untrusted input: a hostile PR can hide instructions in its code. Keep the reviewer and checker in auto mode, or approve their commands one by one. Never give them Bypass on a repository strangers can open PRs against. (In our recorded demo the reviewer ran with Bypass, on our own seeded repository, because Switch 0.40.1 could not relay a chat approval back to Claude Code.)

## Repository layout

```
bin/desk                               the rulebook CLI (bash, gh, jq)
desk.conf                              the rules
templates/maintainer-desk.template.yaml  agents, rooms, link, kickoffs: one import
scripts/seed-demo-repo.sh              creates the demo repository
scripts/install.sh                     installs the desk CLI for the agents
```

## License

MIT
