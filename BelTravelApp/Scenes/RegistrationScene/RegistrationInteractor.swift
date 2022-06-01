//
//  RegistrationInteractor.swift
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
import FirebaseAuth

protocol RegistrationBusinessLogic {
	func createNewUser(request: Registration.Something.Request)
}

protocol RegistrationDataStore {
}

class RegistrationInteractor: RegistrationBusinessLogic, RegistrationDataStore {
	var presenter: RegistrationPresentationLogic?
	var worker: RegistrationWorker?
	// MARK: Do something

	func createNewUser(request: Registration.Something.Request) {
		FirebaseAuthManager.shered.insertNewUser(with: FirebaseAuthManager.AppUserAuthorization(email: request.email,
																								passward: request.passward),
												 fullInformationAboutUser: FullInformationAppUser(email: request.email,
																								  name: request.name,
																								  lastName: request.lastName,
																								  defaultLocation: request.defaultLocation,
																								  image: nil, document: nil)) { [weak self] error in
			if error == nil {
				if let data = request.image?.pngData() {
					FirebaseDatabaseManager().uploadImageData(data: data, serverFileName: "\(request.name).png", folder: "PhotosOfUser") { [weak self] (isSuccess, url) in
						print("uploadImageData: \(isSuccess), \(url!)")
						if Auth.auth().currentUser != nil {
							let response = Registration.Something.Response()
							self?.presenter?.presentAuthorized(response: response)
						}
					}
				}
			}
		}
	}
}
