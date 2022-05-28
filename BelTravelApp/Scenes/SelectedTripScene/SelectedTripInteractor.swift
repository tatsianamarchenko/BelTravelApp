//
//  SelectedTripInteractor.swift
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

protocol SelectedTripBusinessLogic {
	func loadPhotos(request: SelectedTrip.Something.Request)
	func loadParticipants(request: SelectedTrip.Something.Request)
}

protocol SelectedTripDataStore {
	var trip: NewTrip? { get set }
}

class SelectedTripInteractor: SelectedTripBusinessLogic, SelectedTripDataStore {
	var presenter: SelectedTripPresentationLogic?
	var worker: SelectedTripWorker?
	var trip: NewTrip?
	
	// MARK: Do something

	func loadPhotos(request: SelectedTrip.Something.Request) {
		worker = SelectedTripWorker()
		worker?.doSomeWork()
		FirebaseDatabaseManager.shered.fetchSavedImages(tripInformation: trip!) { [weak self] images in
			let response = SelectedTrip.Something.Response(images: images)
			self?.presenter?.presentImages(response: response)
		}
	}

	func loadParticipants(request: SelectedTrip.Something.Request) {
		FirebaseDatabaseManager.shered.fetchParticipants(collection: "\(request.trip.region)Trips", document: "\(request.trip.locationOfParticipants)", secondCollection: "participants", field: "participant") { [weak self] users in
			let response = SelectedTrip.Something.Response(users: users)
			self?.presenter?.presentParticipants(response: response)
		}
	}

}
