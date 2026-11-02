import XCTest
@testable import StudentDirectory

final class StudentStoreMutationTests: XCTestCase {
    func testAddStudentAppendsWithDefaults() throws {
        let store = StudentStore()
        let existingIDs = Set(store.students.map(\.id))

        try store.addStudent(name: "Grace", age: 19)

        XCTAssertEqual(store.students.count, 11)
        let added = try XCTUnwrap(store.students.last)
        XCTAssertEqual(added.name, "Grace")
        XCTAssertEqual(added.age, 19)
        XCTAssertEqual(added.averageGrade, 0)
        XCTAssertFalse(added.isScholarshipHolder)
        XCTAssertTrue(added.subjects.isEmpty)
        XCTAssertEqual(added.avatarName, "avatar-default")
        XCTAssertFalse(existingIDs.contains(added.id))
    }

    func testAddStudentRejectsInvalidInputWithoutMutation() {
        let store = StudentStore()
        let before = store.students

        XCTAssertThrowsError(try store.addStudent(name: "", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.addStudent(name: "  \n ", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Grace", age: 0)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Grace", age: -3)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }

        XCTAssertEqual(store.students, before)
    }

    func testUpdateStudentChangesOnlyNameAndAge() throws {
        let store = StudentStore()
        let original = try XCTUnwrap(store.students.first)

        try store.updateStudent(id: original.id, name: "Ada King", age: 36)

        let updated = try XCTUnwrap(store.students.first)
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.name, "Ada King")
        XCTAssertEqual(updated.age, 36)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
        XCTAssertEqual(store.students.count, 10)
    }

    func testUpdateStudentWithUnknownIDThrowsWithoutMutation() {
        let store = StudentStore()
        let before = store.students
        let unknownID = UUID()

        XCTAssertThrowsError(try store.updateStudent(id: unknownID, name: "Ghost", age: 30)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }

        XCTAssertEqual(store.students, before)
    }

    func testDeleteStudentRemovesOnlyThatStudent() throws {
        let store = StudentStore()
        let removed = store.students[2]

        try store.deleteStudent(id: removed.id)

        XCTAssertEqual(store.students.count, 9)
        XCTAssertFalse(store.students.contains(removed))
        XCTAssertEqual(store.students.map(\.id), StudentSeedData.students.map(\.id).filter { $0 != removed.id })
    }

    func testDeleteStudentWithUnknownIDThrowsWithoutMutation() {
        let store = StudentStore()
        let before = store.students
        let unknownID = UUID()

        XCTAssertThrowsError(try store.deleteStudent(id: unknownID)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }

        XCTAssertEqual(store.students, before)
    }
}
