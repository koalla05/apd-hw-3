# HW3 Student Plan

## Scope

Base assignment (12 pts) plus the optional add/edit/delete bonus (up to 4 pts).
Base is finished and green before the bonus starts.

## Approach

### MVC boundary

- **Model:** `Student`, `StudentSeedData`, `StudentStore` (starter files, stored
  properties unchanged). The store is the only authoritative `[Student]`;
  controllers never keep their own copy of the array, they read
  `store.students` / `store.students(matchingSubject:)` on demand.
- **View:** `StudentCell` (reusable `UITableViewCell`: avatar, name, age,
  average grade, scholarship status) and a `StudentDetailView`; all layout in
  SnapKit.
- **Controller:** `StudentListViewController`, `StudentDetailViewController`,
  `StudentFormViewController` (bonus). Controllers format model values for the
  views and handle taps; no business rules live in views.

### Shared store

`SceneDelegate` creates exactly one `StudentStore` and passes it through
initializers to every controller (list → detail → filtered list → form). No
singleton, no global. Lists reload from the store in `viewWillAppear` and
immediately after any successful add/edit/delete, so visible state is never
stale after returning via standard back behavior.

### Subject filtering

`StudentStore.students(matchingSubject:)` (exact, case-sensitive, store order)
is the single filtering path. The filtered screen reuses
`StudentListViewController` in a "subject" mode (title = subject) rather than a
second list implementation, avoiding duplicated authority and code.
Tested at the store level (order, case-sensitivity, unknown subject → empty)
and in the UI (tap a subject, expect only matching rows).

### UI and accessibility decisions

- Navigation controller root; list title `Students`; push for detail and
  filtered list; standard back button.
- Subjects shown on the detail screen as a vertical `UIStackView` of
  `UIButton`s, `accessibilityIdentifier = "subjectButton.<subject>"`.
- Identifiers: `studentList` (table), `studentCell.<student-id>`,
  `studentDetails` (detail root view), plus `addStudentButton` and
  `editStudentButton` for the bonus.
- Text uses `UIFont.preferredFont(forTextStyle:)` with
  `adjustsFontForContentSizeCategory = true`, `numberOfLines = 0`; cells use
  self-sizing (`automaticDimension`) so layouts survive large Dynamic Type.
- Meaningful `accessibilityLabel`s (e.g. cell combines name, age, grade,
  scholarship status; avatar image marked decorative or labelled with the name).
- No force unwraps on user input (form age parsed with `Int(...)`, errors shown
  in an alert).
- Avatars from bundled assets via `UIImage(named: student.avatarName)` with a
  fallback to `avatar-default`.

### Bonus (add / edit / delete)

- **Add:** `addStudentButton` in the list's nav bar opens a two-field
  (name, age) form; calls `store.addStudent`.
- **Edit:** `editStudentButton` on the detail screen opens the same form,
  pre-filled, name/age only; calls `store.updateStudent`.
- **Delete:** swipe-to-delete on list rows calls `store.deleteStudent`.
- Validation errors (`StudentStoreError`) surface as alerts; failed calls do
  not mutate state (already guaranteed by the store; covered by tests).
- Visible state refreshes after every successful mutation (list reload, detail
  re-reads the student by id).

## Milestones

- [ ] Student list and reusable cell
- [ ] Detail screen and navigation
- [ ] Subject-filtered list
- [ ] Unit and UI tests
- [ ] Optional add/edit/delete bonus, if attempted
- [ ] Local verification and CI review
- [ ] Final diff and evidence review

Each milestone: implement → run focused tests → inspect the diff → add an
`AGENT_WORKLOG.md` row (including any rejected/revised agent suggestion).

## Test plan (~10 student-authored methods, no network/time/random/sleeps)

Unit (`StudentDirectoryTests`):
1. Filter returns only matching students, preserving store order.
2. Filter is case-sensitive (`"math"` → empty) and unknown subject → empty.
3. `addStudent` appends with grade 0, no scholarship, empty subjects,
   `avatar-default`, new UUID.
4. `addStudent` rejects blank/whitespace name and `age <= 0` without mutation.
5. `updateStudent` changes only name/age; unknown id throws `unknownID` with no
   mutation.
6. `deleteStudent` removes the student; unknown id throws with no mutation.  

UI (`StudentDirectoryUITests`):  

7. Launch shows `Students` title and ten `studentCell.*` rows.
8. Tap a row → `studentDetails` appears; back returns to the list.
9. Tap `subjectButton.<subject>` → filtered list with subject title and only
   matching rows.
10. (Bonus) Add a student via the form and see it appear; delete via swipe;
    edit via `editStudentButton`.

Starter tests are left unchanged.

## Verification plan

1. Focused runs while developing, e.g.
   `xcodebuild ... test -only-testing:StudentDirectoryTests`.
2. Final command (exact, from README):
   `xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test`
3. Push and check the GitHub Actions run; record the real URL/status in
   `AGENT_WORKLOG.md` (a local pass is not CI evidence).
4. Before submitting: `git status` clean of build output/secrets, then
   `git rev-parse HEAD` for the 40-character SHA.

## Open decisions / risks

- Add/edit form presentation (modal vs push) and exact cell layout are left to
  implementation; either is compatible with the identifiers above.
- Xcode project uses a file-system or explicit file list; new Swift files must
  be added to the correct targets (check `project.pbxproj` after adding).
- iPhone 17 simulator must exist locally and on `macos-15` CI.
