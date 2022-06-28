//
//  PlaceCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
	static let identifier = "PlaceCollectionViewCell"

	@IBOutlet weak var imageOfLocation: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func config(image: UIImage) {
		imageOfLocation.image = image
		layer.borderWidth = 0
		layer.shadowColor = UIColor.systemGray.cgColor
		layer.shadowOffset = CGSize(width: 0.3, height: 0)
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.5
		layer.cornerRadius = 15
		layer.masksToBounds = false
	}
}
