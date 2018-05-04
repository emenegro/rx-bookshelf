import UIKit

protocol AlertHandler {
}

extension AlertHandler where Self: UIViewController {
    typealias AlertButton = (title: String, style: UIAlertActionStyle, handler: AlertHandler)
    typealias AlertHandler = ((UIAlertAction) -> Swift.Void)?

    func showErrorAlert(withMessage message: String) {
        showAlert(withMessage: message, title: L10n.error.localized)
    }

    func showAlert(withMessage message: String, title: String? = nil) {
        showDialog(withTitle: title, message: message, buttonTitle: nil, buttonHandler: nil)
    }

    func showDialog(withTitle title: String?, message: String?, acceptButtonTitle: String = L10n.accept.localized, buttonTitle: String?, buttonStyle: UIAlertActionStyle = .default, buttonHandler: AlertHandler?) {

        var buttons = [AlertButton(acceptButtonTitle, .default, nil)]

        if let buttonTitle = buttonTitle, let buttonHandler = buttonHandler {
            buttons.append(AlertButton(buttonTitle, buttonStyle, buttonHandler))
        }

        showDialog(withTitle: title, message: message, buttons: buttons)
    }

    func showDialog(withTitle title: String?, message: String?, buttons: [AlertButton]) {

        var actions: [UIAlertAction] = []

        for (title, style, handler) in buttons {
            let action = UIAlertAction(title: title, style: style, handler: handler)
            actions.append(action)
        }

        presentAlert(alert(withTitle: title, message: message, actions: actions))
    }

    private func alert(withTitle title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({ alert.addAction($0) })
        return alert
    }

    private func presentAlert(_ alertController: UIAlertController) {
        var viewController: UIViewController? = self
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
