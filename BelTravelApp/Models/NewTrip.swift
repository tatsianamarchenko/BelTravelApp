//
//  NewTrip.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 29.05.22.
//

import Foundation
import UIKit

struct NewTrip {
	var locationPath: String
	var document: String?
	var locationName: String
	var time: String
	var maxPeople: String
	var description: String
	var creator: String?
	var region: String
	var image: UIImage?
	var participants: [FullInformationAppUser]?
	var locationOfParticipants: String
	var isActive: Bool
}
