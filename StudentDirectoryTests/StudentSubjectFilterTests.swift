import XCTest
@testable import StudentDirectory

final class StudentSubjectFilterTests: XCTestCase {
    func testFilterReturnsOnlyMatchingStudentsInStoreOrder() {
        let store = StudentStore()

        let names = store.students(matchingSubject: "Math").map(\.name)

        XCTAssertEqual(names, ["Ada Lovelace", "Katherine Johnson", "Donald Knuth"])
        XCTAssertTrue(store.students(matchingSubject: "Math").allSatisfy { $0.subjects.contains("Math") })
    }

    func testFilterIsCaseSensitive() {
        let store = StudentStore()

        XCTAssertTrue(store.students(matchingSubject: "math").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "MATH").isEmpty)
    }

    func testFilterWithUnknownSubjectReturnsEmpty() {
        let store = StudentStore()

        XCTAssertTrue(store.students(matchingSubject: "Chemistry").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "").isEmpty)
    }
}
