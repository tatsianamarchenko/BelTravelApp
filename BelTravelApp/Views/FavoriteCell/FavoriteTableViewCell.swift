//
//  FavoriteTableViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 18.05.22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

	static let identifier = "FavoriteTableViewCell"

	@IBOutlet weak var nameLable: UILabel!
	@IBOutlet weak var typeLable: UILabel!
	@IBOutlet weak var placePhoto: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func config(model: Location) {
		nameLable.text = model.name
		typeLable.text = model.type
		placePhoto.image = model.image
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
