import UIKit
import SnapKit

final class StudentFormViewController: UIViewController {
    enum Mode {
        case add
        case edit(studentID: UUID)
    }

    private let store: StudentStore
    private let mode: Mode
    private let onSave: () -> Void

    private let nameField = UITextField()
    private let ageField = UITextField()

    init(store: StudentStore, mode: Mode, onSave: @escaping () -> Void) {
        self.store = store
        self.mode = mode
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
        switch mode {
        case .add: title = "New Student"
        case .edit: title = "Edit Student"
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "cancelStudentButton"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "saveStudentButton"

        configure(field: nameField, placeholder: "Name", identifier: "nameTextField")
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next
        nameField.delegate = self
        configure(field: ageField, placeholder: "Age", identifier: "ageTextField")
        ageField.keyboardType = .numberPad

        let stack = UIStackView(arrangedSubviews: [
            makeCaption("Name"), nameField, makeCaption("Age"), ageField
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(20, after: nameField)

        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)
        scrollView.addSubview(stack)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        if case .edit(let studentID) = mode,
           let student = store.students.first(where: { $0.id == studentID }) {
            nameField.text = student.name
            ageField.text = "\(student.age)"
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let ageText = (ageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let age = Int(ageText) else {
            presentErrorAlert(message: "Age must be a whole number.")
            return
        }
        do {
            switch mode {
            case .add:
                try store.addStudent(name: name, age: age)
            case .edit(let studentID):
                try store.updateStudent(id: studentID, name: name, age: age)
            }
        } catch let error as StudentStoreError {
            presentErrorAlert(message: error.userMessage)
            return
        } catch {
            presentErrorAlert(message: "Something went wrong.")
            return
        }
        onSave()
        dismiss(animated: true)
    }

    private func configure(field: UITextField, placeholder: String, identifier: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.accessibilityIdentifier = identifier
        field.accessibilityLabel = placeholder
    }

    private func makeCaption(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.isAccessibilityElement = false
        return label
    }
}

extension StudentFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameField {
            ageField.becomeFirstResponder()
        }
        return false
    }
}
