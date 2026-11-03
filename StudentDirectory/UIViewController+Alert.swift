import UIKit

extension UIViewController {
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension StudentStoreError {
    var userMessage: String {
        switch self {
        case .blankName: return "Name can't be empty."
        case .nonPositiveAge: return "Age must be greater than zero."
        case .unknownID: return "That student no longer exists."
        }
    }
}
