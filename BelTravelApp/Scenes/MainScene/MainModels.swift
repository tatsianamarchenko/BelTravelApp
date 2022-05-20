//
//  MainModels.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 10.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Main {
  // MARK: Use cases
  
  enum Something {
    struct Request {
		var region: String
		var selectedPopularPlace: Location?
		var newTrip: NewTrip?
    }
    struct Response {
		var locations: [Location]?
		var location: MapPinAnnotation?
		var new: [NewTrip]?
    }
    struct ViewModel {
		var locations: [Location]?
		var createdTrips: [NewTrip]?
		var location: MapPinAnnotation?
    }
  }
}
