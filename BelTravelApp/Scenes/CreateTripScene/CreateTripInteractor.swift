//
//  CreateTripInteractor.swift
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

protocol CreateTripBusinessLogic {
	func createNewTrip(request: CreateTrip.Something.Request)
}

protocol CreateTripDataStore {
	var location: Location? { get set }
	var region: String? { get set }
}

class CreateTripInteractor: CreateTripBusinessLogic, CreateTripDataStore {
	var presenter: CreateTripPresentationLogic?
	var worker: CreateTripWorker?
	var location: Location?
	var region: String?
	// MARK: Do something
	
	func createNewTrip(request: CreateTrip.Something.Request) {
		worker = CreateTripWorker()
		worker?.doSomeWork()
		FirebaseDatabaseManager.shered.addNewTripToDatabase(with: request.trip) { [weak self] result in
			if result == true {
				let response = CreateTrip.Something.Response()
				self?.presenter?.presentSomething(response: response)
			}
			else {
				return
			}
		}
	}
}
