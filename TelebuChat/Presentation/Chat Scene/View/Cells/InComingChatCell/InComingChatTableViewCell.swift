//
//  InComingChatTableViewCell.swift
//  CustomChat
//

import UIKit

class InComingChatTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabelSuperView: UIView!
    @IBOutlet weak var nameLabelBackgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reactionButton: UIButton!
    
    var inComingChatCellUIModel: ChatCellUIModel? {
        didSet {
            messageLabel.text = inComingChatCellUIModel?.message
            nameLabel.text = "\(inComingChatCellUIModel?.userName?.capitalized ?? ""),\(inComingChatCellUIModel?.timeStamp ?? "")"
        }
    }
    
    // creating this programatically since interface builder
    // wont allow scaling if we need to add more reaction images
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        // configuration options
        let iconHeight: CGFloat = 30
        let padding: CGFloat = 5
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            // required for hit testing
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
            return imageView
        })
        // stack view
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        containerView.addSubview(stackView)
        
        let iconsCount = CGFloat(arrangedSubviews.count)
        let width =  iconsCount * iconHeight + (iconsCount + 1) * padding
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // adding shadow to conatiner view so it appears differentiated from other
        // views in the cell
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.frame = containerView.frame
        return containerView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupLongPressGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabelSuperView.addDropShadowToRoundedCorners(cornerShadowPath: .allCorners, edges: [.bottomLeft,.BottomRight,.topRight], radius: 14.0, shadowOpacity: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Custom Methods
    
    fileprivate func setupLongPressGesture() {
        // using panGesture to recongnize user's current pan on reaction imageViews
        iconsContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        removeReactionContainerView()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        } else if gesture.state == .ended {
            // clean up the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
            })
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UIPanGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        // make sure its imageView and not any other view
        if hitTestView is UIImageView {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    // to bring icons to their original position using identity matrix
                    imageView.transform = .identity
                })
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -10)
            })
        }
    }
    
    func addReactionContainerView() {
        // add iconContainer view to content view
        contentView.addSubview(iconsContainerView)
        // pressed location is button frame's y
        let pressedLocation = reactionButton.frame.origin.y
        // transformation of the red box
        let centeredX = (contentView.frame.width - iconsContainerView.frame.width) / 2.5
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation + 5)
        })
    }
    
    func removeReactionContainerView() {
        // clean up the animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let stackView = self.iconsContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconsContainerView.alpha = 0
            
        }, completion: { (_) in
            // remove iconsContainer view once animation is complete
            self.iconsContainerView.removeFromSuperview()
        })
    }
}

