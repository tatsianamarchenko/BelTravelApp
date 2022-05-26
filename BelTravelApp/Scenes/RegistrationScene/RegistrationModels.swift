//
//  RegistrationModels.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 2.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Registration {
	// MARK: Use cases
	
	enum Something {
		struct Request {
			var email: String
			var passward: String
			let name: String
			let lastName: String
			let defaultLocation: String
			let image: UIImage?

		}
		struct Response {
		}
		struct ViewModel {
		}
	}
}
