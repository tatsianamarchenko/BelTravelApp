//
//  ReadyToFinishTripPresenter.swift
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

protocol ReadyToFinishTripPresentationLogic
{
	func presentResult(response: ReadyToFinishTrip.Something.Response)
	func presentParticipants(response: ReadyToFinishTrip.Something.Response)
	func routeToUserViewController()
}

class ReadyToFinishTripPresenter: ReadyToFinishTripPresentationLogic
{
	weak var viewController: ReadyToFinishTripDisplayLogic?
	
	// MARK: Do something
	
	func presentResult(response: ReadyToFinishTrip.Something.Response)
	{
		let viewModel = ReadyToFinishTrip.Something.ViewModel(result: response.result)
		viewController?.displayResult(viewModel: viewModel)
	}
	
	func presentParticipants(response: ReadyToFinishTrip.Something.Response) {
		let viewModel = ReadyToFinishTrip.Something.ViewModel(participants: response.participants)
		viewController?.displayParticipants (viewModel: viewModel)
	}
	
	func routeToUserViewController() {
		viewController?.displayUserViewController()
	}
}
