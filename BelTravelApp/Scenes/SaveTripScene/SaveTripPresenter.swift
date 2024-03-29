//
//  SaveTripPresenter.swift
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

protocol SaveTripPresentationLogic {
	func presentProfile(response: SaveTrip.Something.Response)
}

class SaveTripPresenter: SaveTripPresentationLogic {
	weak var viewController: SaveTripDisplayLogic?

	// MARK: Do something

	func presentProfile(response: SaveTrip.Something.Response) {
		let viewModel = SaveTrip.Something.ViewModel()
		viewController?.displayProfile(viewModel: viewModel)
	}
}
