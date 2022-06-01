//
//  UpcomingTripInformationRouter.swift
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

@objc protocol UpcomingTripInformationRoutingLogic {
	func routeToChatViewController()
	func routeToUserViewController()
}

protocol UpcomingTripInformationDataPassing {
	var dataStore: UpcomingTripInformationDataStore? { get }
}

class UpcomingTripInformationRouter: NSObject, UpcomingTripInformationRoutingLogic, UpcomingTripInformationDataPassing {
	weak var viewController: UpcomingTripInformationViewController?
	var dataStore: UpcomingTripInformationDataStore?

	// MARK: Routing

	func routeToChatViewController() {
		let destinationVC = ChatViewController()
		destinationVC.tripInfo = dataStore?.newTrip
		var destinationDS = destinationVC.router!.dataStore!
		passDataToSomewhere(source: dataStore!, destination: &destinationDS)
		navigateToSomewhere(source: viewController!, destination: destinationVC)
	}

	// MARK: Navigation

	func navigateToSomewhere(source: UpcomingTripInformationViewController, destination: ChatViewController) {
		source.show(destination, sender: nil)
	}

	// MARK: Passing data

	func passDataToSomewhere(source: UpcomingTripInformationDataStore, destination: inout ChatDataStore) {
		destination.newTrip = source.newTrip
	}

	func routeToUserViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController
		destinationVC?.user = dataStore?.user
		var destinationDS = destinationVC?.router!.dataStore!
		passDataToUser(source: dataStore!, destination: &destinationDS!)
		navigateToUserViewController(source: viewController!, destination: destinationVC!)
	}

	// MARK: Navigation

	func navigateToUserViewController(source: UpcomingTripInformationViewController, destination: OtherUserViewController) {
		source.show(destination, sender: nil)
	}

	// MARK: Passing data

	func passDataToUser(source: UpcomingTripInformationDataStore, destination: inout OtherUserDataStore) {
		destination.user = source.user
	}
}
