//
//  AuthorizationInteractor.swift
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

protocol AuthorizationBusinessLogic {
	func doSomething(request: Authorization.Something.Request)
}

protocol AuthorizationDataStore {
}

class AuthorizationInteractor: AuthorizationBusinessLogic, AuthorizationDataStore {
	var presenter: AuthorizationPresentationLogic?
	var worker: AuthorizationWorker?

	// MARK: Do something

	func doSomething(request: Authorization.Something.Request) {
		worker = AuthorizationWorker()
		worker?.doSomeWork()

		FirebaseAuthManager.shered.enterUser(with: FirebaseAuthManager.AppUserAuthorization(email: request.email, passward: request.passward)) { [weak self] result in
			switch result {
			case .success() :
				let response = Authorization.Something.Response()
				self?.presenter?.presentAuthorized(response: response)
			case .failure(let error) : print(error)
			}
		}
	}
}
