import UIKit
import SnapKit

final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let subject: String?
    private let tableView = UITableView(frame: .zero, style: .plain)

    /// Pass a `subject` to show only students whose `subjects` contain it (exact match).
    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
        title = subject ?? "Students"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tableView.accessibilityIdentifier = "studentList"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // New students have no subjects, so adding from a filtered list would
        // not show the new row; only the main list offers it.
        if subject == nil {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            addButton.accessibilityIdentifier = "addStudentButton"
            addButton.accessibilityLabel = "Add student"
            navigationItem.rightBarButtonItem = addButton
        }
    }

    @objc private func addTapped() {
        let form = StudentFormViewController(store: store, mode: .add) { [weak self] in
            self?.tableView.reloadData()
        }
        present(UINavigationController(rootViewController: form), animated: true)
    }

    // Read from the store on demand; the controller keeps no copy of the array.
    private var visibleStudents: [Student] {
        if let subject {
            return store.students(matchingSubject: subject)
        }
        return store.students
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension StudentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = visibleStudents[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentCell.reuseIdentifier,
            for: indexPath
        ) as? StudentCell else {
            return UITableViewCell()
        }
        cell.configure(with: student)
        cell.accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        return cell
    }
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = visibleStudents[indexPath.row]
        let detail = StudentDetailViewController(store: store, studentID: student.id)
        navigationController?.pushViewController(detail, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let student = visibleStudents[indexPath.row]
        do {
            try store.deleteStudent(id: student.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as StudentStoreError {
            presentErrorAlert(message: error.userMessage)
            tableView.reloadData()
        } catch {
            presentErrorAlert(message: "Something went wrong.")
            tableView.reloadData()
        }
    }
}
