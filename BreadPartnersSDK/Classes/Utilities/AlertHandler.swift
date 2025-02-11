import UIKit

internal class AlertHandler {

    private var alertController: UIAlertController?
    private var windowScene: UIWindowScene?

    init(windowScene: UIWindowScene?) {
        self.windowScene = windowScene
    }

    /// Displays or updates a custom alert dialog with a title and message.
    func showAlert(title: String, message: String, showOkButton: Bool) {
        Task { @MainActor in
            // If an alert is already being presented, dismiss it before showing a new one
            if let existingAlert = alertController {
                existingAlert.dismiss(animated: true)
            }

            await presentAlert(
                title: title, message: message, showOkButton: showOkButton)
        }
    }

    /// Helper method to present the alert asynchronously.
    @MainActor
    private func presentAlert(
        title: String, message: String, showOkButton: Bool
    ) async {
        alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)

        if showOkButton {
            let okAction = UIAlertAction(
                title: Constants.okButton, style: .default)
            alertController?.addAction(okAction)
        }

        guard let windowScene = windowScene else { return }
        if let rootViewController = windowScene.windows.first?
            .rootViewController
        {
            var topController = rootViewController
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            topController.present(
                alertController!, animated: true, completion: nil)
        }
    }

    /// Hides the currently displayed custom alert dialog.
    func hideAlert() {
        Task { @MainActor in
            guard let alertController = alertController else { return }
            alertController.dismiss(animated: true)
            self.alertController = nil
        }
    }
}
