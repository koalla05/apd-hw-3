import XCTest

final class StudentBonusUITests: XCTestCase {
    private let adaCellID = "studentCell.00000000-0000-0000-0000-000000000001"

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.tables["studentList"].waitForExistence(timeout: 10))
        return app
    }

    private func clearAndType(_ text: String, in field: XCUIElement) {
        field.tap()
        if let existing = field.value as? String, !existing.isEmpty, existing != field.placeholderValue {
            field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: existing.count))
        }
        field.typeText(text)
    }

    func testAddStudentThroughFormShowsNewRow() {
        let app = launch()

        app.buttons["addStudentButton"].tap()
        let nameField = app.textFields["nameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        clearAndType("Zed Zephyr", in: nameField)
        clearAndType("30", in: app.textFields["ageTextField"])
        app.buttons["saveStudentButton"].tap()

        XCTAssertFalse(nameField.waitForExistence(timeout: 2))
        let list = app.tables["studentList"]
        let newRow = list.cells.matching(NSPredicate(format: "label BEGINSWITH %@", "Zed Zephyr")).firstMatch
        var swipes = 0
        while !newRow.exists && swipes < 6 {
            list.swipeUp()
            swipes += 1
        }
        XCTAssertTrue(newRow.exists)
    }

    func testAddStudentWithBlankNameShowsAlertAndKeepsForm() {
        let app = launch()

        app.buttons["addStudentButton"].tap()
        clearAndType("25", in: app.textFields["ageTextField"])
        app.buttons["saveStudentButton"].tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.staticTexts["Name can't be empty."].exists)
        alert.buttons["OK"].tap()
        XCTAssertTrue(app.textFields["nameTextField"].exists)
    }

    func testEditStudentUpdatesDetailAndList() {
        let app = launch()

        app.tables["studentList"].descendants(matching: .any)[adaCellID].tap()
        app.buttons["editStudentButton"].tap()
        let nameField = app.textFields["nameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        XCTAssertEqual(nameField.value as? String, "Ada Lovelace")
        clearAndType("Ada King", in: nameField)
        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.navigationBars["Ada King"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let row = app.tables["studentList"].descendants(matching: .any)[adaCellID]
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertTrue(row.label.hasPrefix("Ada King"))
    }

    func testSwipeToDeleteRemovesStudent() {
        let app = launch()
        let row = app.tables["studentList"].descendants(matching: .any)[adaCellID]
        XCTAssertTrue(row.waitForExistence(timeout: 5))

        row.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(row.waitForExistence(timeout: 2))
    }
}
