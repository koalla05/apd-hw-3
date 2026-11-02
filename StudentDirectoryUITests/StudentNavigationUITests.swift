import XCTest

final class StudentNavigationUITests: XCTestCase {
    private let firstStudentCellID = "studentCell.00000000-0000-0000-0000-000000000001"

    func testLaunchShowsStudentsTitleAndAllTenSeedRows() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 10))
        let list = app.tables["studentList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        // Rows are created lazily, so scroll until each expected cell appears.
        let expectedIDs = (1...10).map { String(format: "studentCell.00000000-0000-0000-0000-%012d", $0) }
        XCTAssertEqual(expectedIDs.count, 10)
        for id in expectedIDs {
            let cell = list.descendants(matching: .any)[id]
            var swipes = 0
            while !cell.exists && swipes < 6 {
                list.swipeUp()
                swipes += 1
            }
            XCTAssertTrue(cell.exists, "Missing row \(id)")
        }
    }

    func testTappingRowShowsDetailsAndBackReturnsToList() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables["studentList"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))
        let cell = list.descendants(matching: .any)[firstStudentCellID]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.tap()

        let details = app.descendants(matching: .any)["studentDetails"]
        XCTAssertTrue(details.waitForExistence(timeout: 5))

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tables["studentList"].waitForExistence(timeout: 5))
        XCTAssertFalse(details.exists)
    }

    func testTappingSubjectShowsOnlyMatchingStudents() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables["studentList"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))
        list.descendants(matching: .any)[firstStudentCellID].tap()

        let mathButton = app.buttons["subjectButton.Math"]
        XCTAssertTrue(mathButton.waitForExistence(timeout: 5))
        mathButton.tap()

        XCTAssertTrue(app.navigationBars["Math"].waitForExistence(timeout: 5))
        let filtered = app.tables["studentList"]
        XCTAssertTrue(filtered.waitForExistence(timeout: 5))
        XCTAssertEqual(filtered.cells.count, 3)
        for id in ["01", "04", "07"] {
            XCTAssertTrue(filtered.descendants(matching: .any)["studentCell.00000000-0000-0000-0000-0000000000\(id)"].exists)
        }
        XCTAssertFalse(filtered.descendants(matching: .any)["studentCell.00000000-0000-0000-0000-000000000002"].exists)
    }
}
