//
//  ReadyToFinishTripModels.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 28.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ReadyToFinishTrip
{
	// MARK: Use cases
	
	enum Something
	{
		struct Request
		{
			var trip: NewTrip?
			var user: FullInformationAppUser?
		}
		struct Response
		{
			var result: Error?
			var participants: [FullInformationAppUser]?
		}
		struct ViewModel
		{
			var result: Error?
			var participants:  [FullInformationAppUser]?
		}
	}
}
