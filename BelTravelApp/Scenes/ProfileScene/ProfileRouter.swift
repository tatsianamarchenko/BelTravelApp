//
//  ProfileRouter.swift
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

@objc protocol ProfileRoutingLogic {
	func routeToSliderViewController()
	func routeToSelectedFinishedTripViewController()
	func routeToReadyToFinishTripViewController()
}

protocol ProfileDataPassing {
	var dataStore: ProfileDataStore? { get }
}

class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing {
	weak var viewController: ProfileViewController?
	var dataStore: ProfileDataStore?

	// MARK: Routing

	func routeToSliderViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)

		let destinationVC = storyboard.instantiateViewController(withIdentifier: "SliderViewController") as? SliderViewController

		destinationVC?.modalPresentationStyle = .fullScreen
		navigateToSomewhere(source: viewController!, destination: destinationVC!)
	}

	// MARK: Navigation

	func navigateToSomewhere(source: ProfileViewController, destination: SliderViewController) {
		source.present(destination, animated: true)
	}

	func routeToSelectedFinishedTripViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectedTripViewController") as? SelectedTripViewController
		destinationVC?.trip = dataStore?.finishedTrip

		destinationVC?.modalPresentationStyle = .fullScreen
		var destinationDS = destinationVC?.router!.dataStore!
		passDataToSomewhere(source: dataStore!, destination: &destinationDS!)
		navigateToSomewhere(source: viewController!, destination: destinationVC!)
	}

	// MARK: Navigation

	func navigateToSomewhere(source: ProfileViewController, destination: SelectedTripViewController) {
		let nav = UINavigationController(rootViewController: destination)
		nav.modalPresentationStyle = .automatic
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
		}
		source.present(nav, animated: true)
	}

	// MARK: Passing data

	func passDataToSomewhere(source: ProfileDataStore, destination: inout SelectedTripDataStore) {
		destination.trip = source.finishedTrip
	}

	func routeToReadyToFinishTripViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "ReadyToFinishTripViewController") as? ReadyToFinishTripViewController
		destinationVC?.trip = dataStore?.upcomingTrip
		destinationVC?.modalPresentationStyle = .fullScreen
		var destinationDS = destinationVC?.router!.dataStore!
		passDataToReadyToFinishTripViewController(source: dataStore!, destination: &destinationDS!)
		navigateToReadyToFinishTripViewController(source: viewController!, destination: destinationVC!)
	}

	// MARK: Navigation

	func navigateToReadyToFinishTripViewController(source: ProfileViewController, destination: ReadyToFinishTripViewController) {
		source.navigationController?.pushViewController(destination, animated: true)
	}

	// MARK: Passing data

	func passDataToReadyToFinishTripViewController(source: ProfileDataStore, destination: inout ReadyToFinishTripDataStore) {
		destination.trip = source.upcomingTrip
	}
}
