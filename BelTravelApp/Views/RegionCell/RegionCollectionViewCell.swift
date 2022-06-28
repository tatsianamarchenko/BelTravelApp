//
//  RegionCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//

import UIKit

class RegionCollectionViewCell: UICollectionViewCell {

	static let identifier = "RegionCollectionViewCell"

	@IBOutlet weak var regionNameLable: UILabel!
	@IBOutlet weak var regionBoardsImage: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func config(model: Region) {
		regionBoardsImage.image = model.image
		regionNameLable.text = model.name
		layer.borderWidth = 0
		layer.shadowColor = UIColor.systemGray.cgColor
		layer.shadowOffset = CGSize(width: 0.3, height: 0)
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.5
		layer.cornerRadius = 15
		layer.masksToBounds = false
	}
}
