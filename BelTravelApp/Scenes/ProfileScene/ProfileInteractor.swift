//
//  ProfileInteractor.swift
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

protocol ProfileBusinessLogic {
  func loadInformation(request: Profile.Something.Request)
	func saveImageInDatabase(request: Profile.Something.Request)
}

protocol ProfileDataStore {
  //var name: String { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
  var presenter: ProfilePresentationLogic?
  var worker: ProfileWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func loadInformation(request: Profile.Something.Request) {
    worker = ProfileWorker()
    worker?.doSomeWork()

	  FirebaseDatabaseManager.shered.fetchUser { [weak self] user in
		  let response = Profile.Something.Response(person: user, image: user.image)
			  self?.presenter?.presentUserInformation(response: response)
	  }
  }

	func saveImageInDatabase(request: Profile.Something.Request) {
		if let data = request.image?.pngData() {
			FirebaseDatabaseManager().uploadImageData(data: data, serverFileName: "\(request.name!).png") { [weak self] (isSuccess, url) in
				print("uploadImageData: \(isSuccess), \(url!)")
				let response = Profile.Something.Response(image: request.image)
				self?.presenter?.presentNewSavedPhoto(response: response)
			}
		}
	}
}
