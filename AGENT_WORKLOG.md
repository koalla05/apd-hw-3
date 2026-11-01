# HW3 Agent Worklog

If no agent or AI tool was used, say so explicitly. If one was used, record
each material task, inspect the resulting diff, and record one recommendation
you rejected or revised; if none was rejectable, explain why.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-01 | Claude Code (Sonnet 5.5): read all repo files (README, TASKS_AND_GRADES, SUBMISSION, starter Swift sources/tests, CI workflow, project settings) to prepare PLAN.md; read-only, no code changed | Student to review the summary of starter state (stub SceneDelegate, store already has add/update/delete, SnapKit 6.0.0 linked, iOS 18 target) | `git ls-files`, file reads; no diff yet |
| 2026-11-01 | Claude Code: asking student clarifying questions to shape PLAN.md | Student answers decide scope/design choices | Question dialog (see PLAN.md once written) |
| 2026-11-01 | Claude Code: drafted PLAN.md from student's answers (base+bonus; init injection + viewWillAppear reload; vertical subject buttons; ~10 unit+UI tests) | Student to review PLAN.md and adjust; no source code changed | `git diff PLAN.md AGENT_WORKLOG.md` |

## Final review

- Agent/tool disclosure:
- Accepted and rejected/revised recommendations:
- Exact local test command and result:
- CI URL/status:
- Known limitation or remaining risk:
