//
//  ChatListTableViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 26.05.22.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

	static let identifier = "ChatListTableViewCell"

	@IBOutlet weak var tripImage: UIImageView!
	@IBOutlet weak var tripName: UILabel!
	@IBOutlet weak var tripMessage: UILabel!
	@IBOutlet weak var tripMessageDate: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
    }

	func config(model: UserChat) {
		tripImage.image = model.tripImage
		tripName.text = model.tripName
		tripMessage.text = model.messageText
		tripMessageDate.text = model.messageDate
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
