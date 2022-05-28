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

@objc protocol ProfileRoutingLogic
{
  func routeToSliderViewController()
	func routeToSelectedFinishedTripViewController()
}

protocol ProfileDataPassing
{
  var dataStore: ProfileDataStore? { get }
}

class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing
{
	weak var viewController: ProfileViewController?
	var dataStore: ProfileDataStore?

	// MARK: Routing

	func routeToSliderViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "SliderViewController") as! SliderViewController

		destinationVC.modalPresentationStyle = .fullScreen
		var destinationDS = destinationVC.router!.dataStore!
		passDataToSomewhere(source: dataStore!, destination: &destinationDS)
		navigateToSomewhere(source: viewController!, destination: destinationVC)
	}

	// MARK: Navigation

	func navigateToSomewhere(source: ProfileViewController, destination: SliderViewController)
	{
		source.show(destination, sender: nil)
	}

	// MARK: Passing data

	func passDataToSomewhere(source: ProfileDataStore, destination: inout SliderDataStore)
	{
		//    destination.name = source.name
	}

	func routeToSelectedFinishedTripViewController() {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectedTripViewController") as! SelectedTripViewController

		destinationVC.modalPresentationStyle = .fullScreen
		var destinationDS = destinationVC.router!.dataStore!
		passDataToSomewhere(source: dataStore!, destination: &destinationDS)
		navigateToSomewhere(source: viewController!, destination: destinationVC)
	}

	// MARK: Navigation

	func navigateToSomewhere(source: ProfileViewController, destination: SelectedTripViewController) {
		let nav = UINavigationController(rootViewController: destination)
		nav.modalPresentationStyle = .automatic
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
		}
		source.present(nav, animated: true) //(destination, sender: nil)
	}

	// MARK: Passing data

	func passDataToSomewhere(source: ProfileDataStore, destination: inout SelectedTripDataStore) {
		//    destination.name = source.name
	}
}
