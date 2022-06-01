//
//  SelectedTripModels.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SelectedTrip{
	// MARK: Use cases
	
	enum Something {
		struct Request {
			var trip: NewTrip
		}
		struct Response {
			var images: [UIImage]?
			var users: [FullInformationAppUser]?
		}
		struct ViewModel {
			var images: [UIImage]?
			var users: [FullInformationAppUser]?
		}
	}
}
