import UIKit

public extension UIImageView {
    func loadImage(from url: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                    completion(false)
                }
            }
        }
    }
}


public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var hexInt: UInt64 = 0
        
        Scanner(string: hexString).scanHexInt64(&hexInt)
        
        let red = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension UILabel {
    func applyTextStyle(style: PopupTextStyle) {
        if let font = style.font {
            self.font = font
        }
        
        if let textColor = style.textColor {
            self.textColor = textColor
        }
        
        if let textSize = style.textSize {
            self.font = self.font?.withSize(textSize)
        }
    }
}
