import Foundation

extension PopupController {
    @objc func closeButtonTapped() {
        callback(.popupClosed)
        dismiss(animated: true, completion: nil)
    }

    @objc func actionButtonTapped() {
        callback(.actionButtonTapped)
        if let placementModel = webViewPlacementModel {
            displayEmbeddedOverlay(popupModel: placementModel)
        } else {
            callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                Constants.somethingWentWrong
                        ])))
        }
    }
}
