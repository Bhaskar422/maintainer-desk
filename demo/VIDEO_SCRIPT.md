# Demo video script (about 2:30)

Record at 1080p or higher. Turn on Do Not Disturb. Put Discord on the left half of the
screen and Slack on the right; keep a browser tab per GitHub page ready.
Most scenes are the real run from 7 November (rooms `textkit-contributors` on Discord and
`textkit-maintainers` on Slack, all agents in auto mode, no Bypass), scrolled through.
Scene 5 is done live, on a free issue (#3 or #1).
Captions are what to put on screen (or say, if you narrate).

| # | Time | On screen | Caption / voice-over |
|---|------|-----------|----------------------|
| 1 | 0:00–0:15 | github.com/sandbox-quantum/switch/issues/843, scroll the assignee list (8 people) | "This week, Switch's own hackathon issues: 63 open, 538 assignments. #843 has 8 assignees under a one-person rule. 388 assignments idle for 48h+. Maintainers check all of it by hand." |
| 2 | 0:15–0:25 | README diagram (two rooms, three agents, GitHub) | "Maintainer Desk: Switch agents run the contributor queue. Maintainers decide." |
| 3 | 0:25–0:50 | Discord #textkit-contributors: "@textkit-desk can I take #6? my GitHub is Bhaskar422" → desk "Checked: #6 is free…". Cut to Slack #textkit-maintainers: the Claim card. Then "@textkit-desk approve 6" → "Assigned #6". Cut to github.com/Bhaskar422/desk-demo/issues/6 (assignee + comment). | "A contributor asks in Discord. The desk checks the rules against GitHub and passes the claim to the maintainers' private Slack. One reply, and GitHub is updated." |
| 4 | 0:50–1:00 | Discord: "can I take #4? my GitHub is octocat" → instant refusal with free issues. | "Rule breaks never reach a maintainer." |
| 5 | 1:00–1:15 | **Live:** claim #3 in Discord, approve it in Slack, show the contributor's "#3 is yours" in Discord. | "Live, right now: same flow, about thirty seconds." |
| 6 | 1:15–1:45 | Slack, PR #10 thread: Reviewer (Claude) asks Checker (Codex) for an independent review. Both say LOW-EFFORT. The combined message with "Suggested command". Show it sent → github.com/Bhaskar422/desk-demo/pull/10 closed with the comment. | "Two agents on two providers review every PR independently. They agree, so the maintainer sends one ready-made, kind reply." |
| 7 | 1:45–2:10 | Slack, PR #9: Reviewer READY vs Checker CHANGES (truncate not exported). The "We disagree, your call" message → the CHANGES command sent → the comment on github.com/Bhaskar422/desk-demo/pull/9. | "When they disagree, nobody guesses: the maintainer sees both arguments and makes the call." |
| 8 | 2:10–2:25 | Slack: "@textkit-desk stats" reply. Then the README section "Why this needs Switch". | "Two chat apps, two linked rooms, Claude and Codex in one team, humans approving in chat. All in auto mode, no Bypass. Without Switch, none of this talks to each other." |
| 9 | 2:25–2:30 | github.com/Bhaskar422/maintainer-desk | "Import one Switch template. Try it in preview mode on your own repo." |

## Lines to keep exactly
- "Agents prepare every decision. People make it."
- Only say "Codex checked the PR out and ran it" if the checker's EVIDENCE in the PR #9 or #10 thread shows it ran the tests.

## Do not show
- Bot tokens, the Slack app credentials page, or the Discord Developer Portal.
- Console agent settings pages (nothing to hide, just noise).

## Upload
YouTube, unlisted (or Loom). Put the link at the top of README.md and in the submission form.
