//
//  UpcomingTripCollectionViewCell.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//

import UIKit

class UpcomingTripCollectionViewCell: UICollectionViewCell {

	static let identifier = "UpcomingTripCollectionViewCell"

	@IBOutlet weak var placeImage: UIImageView!
	@IBOutlet weak var placeName: UILabel!
	@IBOutlet weak var tripDate: UILabel!
	@IBOutlet weak var quantityOfPeople: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

	func config(model: CreatedTrip) {
		placeImage.image = model.image
		placeName.text = model.name
		tripDate.text = model.date.formatted()
		quantityOfPeople.text = model.quantity
	}

}

struct CreatedTrip {
	var name: String
	var date: Date
	var quantity: String
	var image: UIImage
}
