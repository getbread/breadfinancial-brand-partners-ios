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
        }
    }
}
