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
		regionBoardsImage.image = model.image.getImage()
		regionNameLable.text = model.name
	}

}

struct Region {
	var image: Image
	var name: String
	var identifier: String

}

struct Image: Codable {
  let imageData: Data?
  init(withImage image: UIImage) {
	self.imageData = image.pngData()
  }
  func getImage() -> UIImage? {
	guard let imageData = self.imageData else {
	  return nil
	}
	let image = UIImage(data: imageData)
	return image
  }
}

