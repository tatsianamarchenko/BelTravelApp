//
//  SaveTripInteractor.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 28.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SaveTripBusinessLogic {
	func saveImages(request: SaveTrip.Something.Request)
}

protocol SaveTripDataStore {
	var trip: NewTrip? { get set }
}

class SaveTripInteractor: SaveTripBusinessLogic, SaveTripDataStore {
	var presenter: SaveTripPresentationLogic?
	var worker: SaveTripWorker?
	var trip: NewTrip?

	// MARK: Do something

	func saveImages(request: SaveTrip.Something.Request) {
		worker = SaveTripWorker()
		worker?.doSomeWork()
		for i in 0..<request.photos!.count{
			if let data = request.photos?[i].pngData() {
				FirebaseDatabaseManager.shered.saveImages(tripInformation: trip!, data: data, serverFileName: "\(request.photos?[i].size)\(i)", folder: trip?.document ?? "") { isSuccess, url in
					print(self.trip?.document as Any)

				}}
		}
		FirebaseDatabaseManager.shered.finishTrip(with: trip!)
		let response = SaveTrip.Something.Response()
		presenter?.presentProfile(response: response)
	}
}
