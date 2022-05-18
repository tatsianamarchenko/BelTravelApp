//
//  MainPresenter.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 10.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainPresentationLogic {
  func presentPopularPlaces(response: Main.Something.Response)
	func presentSelectedPopularlocation()
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  // MARK: Do something
  
  func presentPopularPlaces(response: Main.Something.Response) {
	  let viewModel = Main.Something.ViewModel(locations: response.locations)
    viewController?.displayPopularPlaces(viewModel: viewModel)
  }

	func presentSelectedPopularlocation() {
		viewController?.presentSelectedPopularPlaceViewController()
	}
}
