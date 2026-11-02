import UIKit
import SnapKit

final class StudentCell: UITableViewCell {
    static let reuseIdentifier = "StudentCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let gradeLabel = UILabel()
    private let scholarshipLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")
        nameLabel.text = student.name
        ageLabel.text = "Age \(student.age)"
        gradeLabel.text = "Average grade: \(String(format: "%.1f", student.averageGrade))"
        scholarshipLabel.text = student.isScholarshipHolder ? "Scholarship" : "No scholarship"

        accessibilityLabel = [
            student.name,
            "age \(student.age)",
            "average grade \(String(format: "%.1f", student.averageGrade))",
            student.isScholarshipHolder ? "scholarship holder" : "no scholarship"
        ].joined(separator: ", ")
    }

    private func setUpViews() {
        isAccessibilityElement = true
        accessoryType = .disclosureIndicator

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 28
        avatarImageView.isAccessibilityElement = false

        configure(label: nameLabel, style: .headline)
        configure(label: ageLabel, style: .subheadline)
        configure(label: gradeLabel, style: .footnote)
        configure(label: scholarshipLabel, style: .footnote)

        let textStack = UIStackView(arrangedSubviews: [nameLabel, ageLabel, gradeLabel, scholarshipLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
            make.top.greaterThanOrEqualTo(contentView.layoutMarginsGuide)
            make.bottom.lessThanOrEqualTo(contentView.layoutMarginsGuide)
        }
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }

    private func configure(label: UILabel, style: UIFont.TextStyle) {
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        if style == .headline {
            label.textColor = .label
        } else {
            label.textColor = .secondaryLabel
        }
    }
}
