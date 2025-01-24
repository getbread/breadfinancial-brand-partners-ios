import UIKit

protocol AlertHandlerProtocol {
    func showAlert(title: String, message: String, showOkButton: Bool)
    func hideAlert()
}

internal class AlertHandler: AlertHandlerProtocol {
    
    private var alertController: UIAlertController?
    private var windowScene: UIWindowScene?

    init(windowScene: UIWindowScene?) {
        self.windowScene = windowScene
    }
    
    /// Displays or updates a custom alert dialog with a title and message.
    func showAlert(title: String, message: String, showOkButton: Bool) {
        // If an alert is already being presented, dismiss it before showing a new one
        if let existingAlert = alertController, existingAlert.isBeingPresented {
            existingAlert.dismiss(animated: false) {
                // Present the new alert only after dismissing the existing one
                self.presentAlert(title: title, message: message, showOkButton: showOkButton)
            }
        } else {
            // Directly present if there's no existing alert
            presentAlert(title: title, message: message, showOkButton: showOkButton)
        }
    }
    
    /// Helper method to present the alert.
    private func presentAlert(title: String, message: String, showOkButton: Bool) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add the OK action only if showOkButton is true
        if showOkButton {
            let okAction = UIAlertAction(title: Constants.okButton, style: .default, handler: nil)
            alertController?.addAction(okAction)
        }
        
        // Present the alert
        DispatchQueue.main.async {
            guard let windowScene = self.windowScene else { return }
            
            if let rootViewController = windowScene.windows.first?.rootViewController {
                // Find the topmost view controller
                var topController = rootViewController
                while let presentedVC = topController.presentedViewController {
                    topController = presentedVC
                }
                topController.present(self.alertController!, animated: true, completion: nil)
            }
        }
    }
    
    /// Hides the currently displayed custom alert dialog, if any.
    func hideAlert() {
        // Check if the alert controller is currently being presented
        if ((alertController?.isBeingPresented) != nil) {
            DispatchQueue.main.async {
                self.alertController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
