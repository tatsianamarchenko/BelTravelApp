//
//  ProfilePresenter.swift
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

protocol ProfilePresentationLogic {
	func presentUserInformation(response: Profile.Something.Response)
	func presentNewSavedPhoto(response: Profile.Something.Response)
}

class ProfilePresenter: ProfilePresentationLogic {
  weak var viewController: ProfileDisplayLogic?
  
  // MARK: Do something
  
  func presentUserInformation(response: Profile.Something.Response) {
	  let viewModel = Profile.Something.ViewModel(name: response.person?.name ?? "", lastName: response.person?.lastName ?? "", defaultLocation: response.person?.defaultLocation ?? "", numberOfTripsOfUser: response.person?.email ?? "")
	  viewController?.displayUserInformation(viewModel: viewModel)
  }

	func presentNewSavedPhoto(response: Profile.Something.Response) {
		let viewModel = Profile.Something.ViewModel(newImage: response.image)
		viewController?.displayNewPhotosOfUser(viewModel: viewModel)
	}

}
