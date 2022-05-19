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

	func config(model: NewTrip) {
		placeImage.image = UIImage(systemName: "heart")
		placeName.text = model.locationName
		tripDate.text = model.time
		quantityOfPeople.text = model.maxPeople
	}

}

//struct CreatedTrip {
//	var name: String
//	var date: Date
//	var quantity: String
//	var image: UIImage
//}
