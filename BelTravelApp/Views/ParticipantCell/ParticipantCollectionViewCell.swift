//
//  ParticipantCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//

import UIKit

class ParticipantCollectionViewCell: UICollectionViewCell {

	static let identifier = "ParticipantCollectionViewCell"

	@IBOutlet weak var photoOfUser: UIImageView!
	@IBOutlet weak var nameLable: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func config(model: FirebaseAuthManager.FullInformationAppUser) {
		photoOfUser.image = model.image
		nameLable.text = model.name
	}
}
