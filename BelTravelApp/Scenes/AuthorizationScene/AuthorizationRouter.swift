//
//  AuthorizationRouter.swift
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

@objc protocol AuthorizationRoutingLogic {
	func routeToMessengerTabBarViewController()
}

protocol AuthorizationDataPassing {
	var dataStore: AuthorizationDataStore? { get }
}

class AuthorizationRouter: NSObject, AuthorizationRoutingLogic, AuthorizationDataPassing {
	weak var viewController: AuthorizationViewController?
	var dataStore: AuthorizationDataStore?

	// MARK: Routing

	func routeToMessengerTabBarViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
		destinationVC?.modalPresentationStyle = .fullScreen
		navigateToMessengerTabBarViewController(source: viewController!, destination: destinationVC!)
	}

	//   MARK: Navigation

	func navigateToMessengerTabBarViewController(source: AuthorizationViewController, destination: TabBarViewController) {
		source.show(destination, sender: nil)
	}
}
