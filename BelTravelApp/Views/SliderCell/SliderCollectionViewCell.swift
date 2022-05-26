//
//  SliderCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 2.05.22.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {

static let identifier = "SliderCollectionViewCell"

	@IBOutlet weak var lable: UILabel!
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var registrationButtonOutlet: UIButton!
	@IBOutlet weak var authorizationButtonOutlet: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

	func config(model: Slider.Something.ViewModel) {
		lable.text = model.lable
		image.image = model.image
		if model.id == 2 {
			registrationButtonOutlet.isHidden = false
			authorizationButtonOutlet.isHidden = false
		}
	}
}
