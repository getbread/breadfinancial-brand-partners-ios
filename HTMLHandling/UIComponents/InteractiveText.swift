import UIKit

internal class InteractiveText: UITextView {
    private var tapHandler: ((String) -> Void)?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isEditable = false
        isScrollEnabled = false
        isSelectable = true
        backgroundColor = .clear
        dataDetectorTypes = .link
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    public func configure(with attributedText: NSAttributedString, tapHandler: ((String) -> Void)? = nil) {
        self.attributedText = attributedText
        self.tapHandler = tapHandler
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let layoutManager = layoutManager as NSLayoutManager?,
              let textContainer = textContainer as NSTextContainer?,
              let text = attributedText else { return }
        
        let location = gesture.location(in: self)
        let textContainerOffset = CGPoint(
            x: (bounds.size.width - textContainer.size.width) * 0.5 - textContainerInset.left,
            y: (bounds.size.height - textContainer.size.height) * 0.5 - textContainerInset.top
        )
        let textContainerLocation = CGPoint(
            x: location.x - textContainerOffset.x,
            y: location.y - textContainerOffset.y
        )
        
        let characterIndex = layoutManager.characterIndex(
            for: textContainerLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        if characterIndex < text.length {
            let attributes = text.attributes(at: characterIndex, effectiveRange: nil)
            if let link = attributes[.link] as? String {
                tapHandler?(link)
            }
        }
    }
}
