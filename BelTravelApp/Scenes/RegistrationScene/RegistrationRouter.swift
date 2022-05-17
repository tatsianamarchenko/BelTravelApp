//
//  RegistrationRouter.swift
//  Messenger
//
//  Created by Tatsiana Marchanka on 2.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol RegistrationRoutingLogic {
  func routeToMessengerTabBarViewController()
}

protocol RegistrationDataPassing {
  var dataStore: RegistrationDataStore? { get }
}

class RegistrationRouter: NSObject, RegistrationRoutingLogic, RegistrationDataPassing {
  weak var viewController: RegistrationViewController?
  var dataStore: RegistrationDataStore?
  
  // MARK: Routing
  
	func routeToMessengerTabBarViewController (){
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
		destinationVC.modalPresentationStyle = .fullScreen
		navigateToMessengerTabBarViewController(source: viewController!, destination: destinationVC)
	}

	// MARK:  Navigation
  
  func navigateToMessengerTabBarViewController(source: RegistrationViewController, destination: MainViewController) {
    source.show(destination, sender: nil)
  }
}