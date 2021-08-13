//
//  OutGoingChatTableViewCell.swift
//  CustomChat

import UIKit

class OutGoingChatTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var messageLabelSuperView: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var outgoingChatCellUIModel: ChatCellUIModel? {
        didSet {
            messageLabel.text = outgoingChatCellUIModel?.message
            timeStampLabel.text = outgoingChatCellUIModel?.timeStamp
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabelSuperView.addDropShadowToRoundedCorners(cornerShadowPath: .allCorners, edges: [.bottomLeft, .topRight, .topLeft], radius: 14.0, shadowOpacity: 0.0)
    }
}
