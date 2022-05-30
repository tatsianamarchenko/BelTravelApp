//
//  AllLocationsInteractor.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 16.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AllLocationsBusinessLogic {
  func loadLocation(request: AllLocations.Something.Request)
	func setLocation(request: AllLocations.Something.Request)
}

protocol AllLocationsDataStore {
	var region: String { get set }
	var location: Location? { get set }
}

class AllLocationsInteractor: AllLocationsBusinessLogic, AllLocationsDataStore {
	var location: Location?
	var presenter: AllLocationsPresentationLogic?
	var worker: AllLocationsWorker?
	var region: String = ""

	// MARK: Do something

	func setLocation(request: AllLocations.Something.Request) {
		location = request.location
		self.presenter?.presentLocation()
	}

	func loadLocation(request: AllLocations.Something.Request) {
		worker = AllLocationsWorker()
		worker?.doSomeWork()
		guard let reg = request.region else {
			return
		}
		region = reg
		FirebaseDatabaseManager.shered.fetchLocationData(collection: reg) { [weak self] locations in
			let response = AllLocations.Something.Response(locations: locations)
			self?.presenter?.presentLocations(response: response)
		}
	}
}
