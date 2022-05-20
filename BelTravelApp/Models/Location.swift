//
//  Location.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 20.05.22.
//

import Foundation
import UIKit

struct NewTrip {
	var locationPath: String
	var locationName: String
	var time: String
	var maxPeople: String
	var description: String
	var creator: String?
	var region: String
}

struct Location {
	var lat: Double
	var lng: Double
	var description: String
	var image: UIImage
	var name: String
	var type: String
	var firebasePath: String
	var wantToVisit: [FirebaseAuthManager.FullInformationAppUser]
	var isPopular: Bool
}