# HW3 Agent Worklog

If no agent or AI tool was used, say so explicitly. If one was used, record
each material task, inspect the resulting diff, and record one recommendation
you rejected or revised; if none was rejectable, explain why.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-01 | Claude Code (Sonnet 5.5): read all repo files (README, TASKS_AND_GRADES, SUBMISSION, starter Swift sources/tests, CI workflow, project settings) to prepare PLAN.md; read-only, no code changed | Student to review the summary of starter state (stub SceneDelegate, store already has add/update/delete, SnapKit 6.0.0 linked, iOS 18 target) | `git ls-files`, file reads; no diff yet |
| 2026-11-01 | Claude Code: asking student clarifying questions to shape PLAN.md | Student answers decide scope/design choices | Question dialog (see PLAN.md once written) |
| 2026-11-01 | Claude Code: drafted PLAN.md from student's answers (base+bonus; init injection + viewWillAppear reload; vertical subject buttons; ~10 unit+UI tests) | Student to review PLAN.md and adjust; no source code changed | `git diff PLAN.md AGENT_WORKLOG.md` |
| 2026-11-01 | Claude Code: asked student implementation questions for milestone 1 (cell layout, scholarship display, data source, subject mode) | Student chose: avatar-left/text-stack-right; text "Scholarship"/"No scholarship"; classic `UITableViewDataSource`; plain list only (subject mode deferred to milestone 3) | Question dialog answers |
| 2026-11-01 | Claude Code: implemented milestone 1 — added `StudentCell.swift`, `StudentListViewController.swift`; replaced stub in `SceneDelegate.swift` with one shared `StudentStore` + nav controller. Row tap only deselects (detail is milestone 2) | Student to review diff: no controller-owned array (reads `store.students`), SnapKit layout, Dynamic Type fonts, identifiers `studentList` / `studentCell.<uuid>`, avatar fallback to `avatar-default` | `xcodebuild ... build` → BUILD SUCCEEDED; full `xcodebuild ... test` (iPhone 17) → TEST SUCCEEDED (starter tests only; not yet visually checked in Simulator, no CI run) |
| 2026-11-02 | Claude Code: fixed black screen on launch. Cause: generated scene manifest has no delegate class and `StudentDirectoryApp` returned a bare `UISceneConfiguration`, so `SceneDelegate` never ran. Set `configuration.delegateClass = SceneDelegate.self` in `StudentDirectoryApp.swift` (starter file touched; starter tests unchanged) | Student to review the one-line starter change and confirm the list shows in their own Simulator | Build succeeded; `simctl` screenshot on iPhone 17 shows `Students` title and rows with avatar, name, age, grade, scholarship status. Full `test` not re-run after this change |
| 2026-11-02 | Claude Code: asked student milestone 2 questions (scrollable layout, pass store + student id, subject buttons shown now without action, add navigation UI test now). Implemented `StudentDetailView.swift`, `StudentDetailViewController.swift`, row-tap push in `StudentListViewController.swift`, and `StudentDirectoryUITests/StudentNavigationUITests.swift` (new file; starter tests untouched). Revised my own first draft of the avatar centering (add/remove/re-add) into a plain container view before testing | Student to review: detail re-reads the student by id in `viewWillAppear` and pops if missing; `studentDetails` identifier on root view; `subjectButton.<subject>` buttons; Student ID shown as a field, `avatarName` shown as the image rather than text | `xcodebuild ... test` (iPhone 17) → TEST SUCCEEDED incl. `testTappingRowShowsDetailsAndBackReturnsToList`; one log line showed a runner launch error on a clone device but the run still passed; detail screen not yet visually checked in Simulator; no CI run |

## Final review

- Agent/tool disclosure:
- Accepted and rejected/revised recommendations:
- Exact local test command and result:
- CI URL/status:
- Known limitation or remaining risk:
