import UIKit
import SnapKit

final class StudentDetailView: UIView {
    private let scrollView = UIScrollView()
    private let avatarImageView = UIImageView()
    private let idLabel = UILabel()
    private let subjectsStack = UIStackView()
    private let fieldsStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")
        avatarImageView.accessibilityLabel = "\(student.name) avatar"

        fieldsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fields: [(String, String)] = [
            ("Name", student.name),
            ("Age", "\(student.age)"),
            ("Average grade", String(format: "%.1f", student.averageGrade)),
            ("Scholarship", student.isScholarshipHolder ? "Yes" : "No"),
            ("Student ID", student.id.uuidString)
        ]
        for (title, value) in fields {
            fieldsStack.addArrangedSubview(makeFieldView(title: title, value: value))
        }

        subjectsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        subjectsStack.addArrangedSubview(makeLabel(text: "Subjects", style: .caption1, color: .secondaryLabel))
        if student.subjects.isEmpty {
            subjectsStack.addArrangedSubview(makeLabel(text: "No subjects", style: .body, color: .label))
        }
        for subject in student.subjects {
            subjectsStack.addArrangedSubview(makeSubjectButton(subject: subject))
        }
    }

    private func setUpViews() {
        backgroundColor = .systemBackground
        accessibilityIdentifier = "studentDetails"

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.isAccessibilityElement = true
        avatarImageView.accessibilityTraits = .image

        fieldsStack.axis = .vertical
        fieldsStack.spacing = 12

        subjectsStack.axis = .vertical
        subjectsStack.alignment = .leading
        subjectsStack.spacing = 8

        // Container lets the fixed-size avatar sit centered in the full-width stack.
        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.size.equalTo(120)
        }

        let contentStack = UIStackView(arrangedSubviews: [avatarContainer, fieldsStack, subjectsStack])
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.alignment = .fill

        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }
    }

    private func makeFieldView(title: String, value: String) -> UIView {
        let titleLabel = makeLabel(text: title, style: .caption1, color: .secondaryLabel)
        let valueLabel = makeLabel(text: value, style: .body, color: .label)
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.isAccessibilityElement = true
        stack.accessibilityLabel = "\(title), \(value)"
        return stack
    }

    private func makeLabel(text: String, style: UIFont.TextStyle, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = color
        return label
    }

    private func makeSubjectButton(subject: String) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = subject
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = UIFont.preferredFont(forTextStyle: .body)
            return attributes
        }
        let button = UIButton(configuration: configuration)
        button.titleLabel?.numberOfLines = 0
        button.accessibilityIdentifier = "subjectButton.\(subject)"
        button.accessibilityLabel = subject
        return button
    }
}
