import UIKit

final class StudentDetailViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID
    private let detailView = StudentDetailView()

    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.onSubjectTap = { [weak self] subject in
            guard let self else { return }
            let list = StudentListViewController(store: self.store, subject: subject)
            self.navigationController?.pushViewController(list, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        guard let student = store.students.first(where: { $0.id == studentID }) else {
            navigationController?.popViewController(animated: false)
            return
        }
        title = student.name
        detailView.configure(with: student)
    }
}
