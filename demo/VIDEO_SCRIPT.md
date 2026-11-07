# Demo video script (about 2:30)

Record at 1080p or higher. Turn on Do Not Disturb. Put Discord on the left half of the
screen and Slack on the right; keep a browser tab per GitHub page ready.
Most scenes are the real run from 7 November, scrolled through; scene 6 is done live.
Captions are what to put on screen (or say, if you narrate).

| # | Time | On screen | Caption / voice-over |
|---|------|-----------|----------------------|
| 1 | 0:00–0:15 | github.com/sandbox-quantum/switch/issues/843, scroll the assignee list (8 people) | "This week, Switch's own hackathon issues: 63 open, 538 assignments. #843 has 8 assignees under a one-person rule. 388 assignments idle for 48h+. Maintainers check all of it by hand." |
| 2 | 0:15–0:25 | README diagram (two rooms, three agents, GitHub) | "Maintainer Desk: Switch agents run the contributor queue. Maintainers decide." |
| 3 | 0:25–0:50 | Discord #oss-contributors: Boss421 "@oss-desk can I take #4? my GitHub is Bhaskar422" → desk "Checked: #4 is free…". Cut to Slack #oss-maintainers: the Claim card "Eligible: 3 open PRs of 5, holds 3 issues of 5". | "A contributor asks in Discord. The desk checks the rules against GitHub and passes the claim to the maintainers' private Slack." |
| 4 | 0:50–1:05 | Slack: "@oss-desk approve 4" → "Assigned #4". Cut to github.com/Bhaskar422/desk-demo/issues/4 (assignee + comment). Cut to Discord: "@Boss421 Good news… #4 is yours". | "One reply. GitHub is updated and the contributor hears back, in their own app." |
| 5 | 1:05–1:15 | Discord: "can I take #2? my GitHub is octocat" → instant refusal with free issues. | "Rule breaks never reach a maintainer." |
| 6 | 1:15–1:50 | Slack, PR #11 thread: Reviewer (Claude) asks Checker (Codex) for an independent review. Show the Checker's EVIDENCE (it ran the code: hello--world, café-東京 fail). Then the combined verdict "We agree… Suggested command". Send it (or show it sent) → github.com/Bhaskar422/desk-demo/pull/11 closed with the comment. | "Two agents on two providers review every PR independently. Codex checked the PR out and ran it. They agree, so the maintainer sends one ready-made, kind reply." |
| 7 | 1:50–2:10 | Slack, PR #9: Reviewer READY vs Checker CHANGES (truncate not exported). The "We disagree, your call" message. **Live:** send the CHANGES comment command it offers → show the comment on github.com/Bhaskar422/desk-demo/pull/9. | "When they disagree, nobody guesses: the maintainer sees both arguments and makes the call." |
| 8 | 2:10–2:25 | Slack: "@oss-desk stats" reply. Then the README section "Why this needs Switch". | "Two chat apps, two linked rooms, Claude and Codex in one team, humans approving in chat. Without Switch, none of this talks to each other." |
| 9 | 2:25–2:30 | github.com/Bhaskar422/maintainer-desk | "Import one Switch template. Try it in preview mode on your own repo." |

## Lines to keep exactly
- "Agents prepare every decision. People make it."
- "Codex checked the PR out and ran it."

## Do not show
- Bot tokens, the Slack app credentials page, or the Discord Developer Portal.
- The earlier permission errors (they are explained in the README instead).

## Upload
YouTube, unlisted (or Loom). Put the link at the top of README.md and in the submission form.
