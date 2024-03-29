//
//  ParticipantCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//

import UIKit
import FirebaseAuth
class ParticipantCollectionViewCell: UICollectionViewCell {

	static let identifier = "ParticipantCollectionViewCell"

	@IBOutlet weak var photoOfUser: UIImageView!
	@IBOutlet weak var nameLable: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func config(model: FullInformationAppUser) {
		photoOfUser.image = model.image
		nameLable.text = model.name
		layer.borderWidth = 0
		layer.shadowColor = UIColor.systemGray.cgColor
		layer.shadowOffset = CGSize(width: 0.3, height: 0)
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.5
		layer.cornerRadius = 15
		layer.masksToBounds = false
		if model.email == Auth.auth().currentUser?.email {
			backgroundColor = #colorLiteral(red: 1, green: 0.5566172004, blue: 0.4395110607, alpha: 1)
		} else {
			backgroundColor = #colorLiteral(red: 0.862870574, green: 0.725133419, blue: 0.9991236329, alpha: 1)
		}
	}
}
