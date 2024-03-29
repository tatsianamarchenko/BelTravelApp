//
//  OtherUserInteractor.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 25.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OtherUserBusinessLogic {
	func loadTrips(request: OtherUser.Something.Request)
	func setFinishTrip(request: OtherUser.Something.Request)
}

protocol OtherUserDataStore {
	var user: FullInformationAppUser? { get set }
	var finishedTrip: NewTrip? { get set }
}

class OtherUserInteractor: OtherUserBusinessLogic, OtherUserDataStore {
	var presenter: OtherUserPresentationLogic?
	var worker: OtherUserWorker?
	var user: FullInformationAppUser?
	var finishedTrip: NewTrip?

	// MARK: Do something

	func loadTrips(request: OtherUser.Something.Request) {
		worker = OtherUserWorker()
		worker?.doSomeWork()
		FirebaseDatabaseManager.shered.fetchUserTrips(document: user) { [weak self] upcomingTrips, finishedTrips in
			let response = OtherUser.Something.Response(upcomingTrips: upcomingTrips, finishedTrips: finishedTrips)
			self?.presenter?.presenTripsInformation(response: response)
		}
	}

	func setFinishTrip(request: OtherUser.Something.Request) {
		finishedTrip = request.finishedTrip
		self.presenter?.presentFinishedTrip()
	}

}
