//
//  Location.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 20.05.22.
//

import Foundation
import UIKit

struct Location {
	var lat: Double
	var lng: Double
	var description: String
	var image: UIImage
	var name: String
	var type: String
	var firebasePath: String
	var wantToVisit: [FullInformationAppUser]
	var isPopular: Bool
	var locationWhoLiked: String
	var region: String
}
