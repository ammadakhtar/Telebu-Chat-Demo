//
//  PlaceHolderTextView.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit

@IBDesignable class PlaceholderTextView: UITextView {
    
    private struct Constants {
        static let defaultiOSPlaceholderColor = UIColor.CustomColorFromHexaWithAlpha("C6C6C6", alpha: 1.0)
    }
    public let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    @IBInspectable open var placeholderString: String = "" {
        didSet {
            placeholderLabel.text = placeholderString
        }
    }
    
    @IBInspectable open var placeholderTextColor: UIColor = PlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    override open var font: UIFont! {
        didSet {
            if placeholderFont == nil {
                placeholderLabel.font = font
            }
        }
    }
    
    open var placeholderFont: UIFont? {
        didSet {
            let font = (placeholderFont != nil) ? placeholderFont : self.font
            placeholderLabel.font = font
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = Constants.defaultiOSPlaceholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
                                                            options: [],
                                                            metrics: nil,
                                                            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
}
