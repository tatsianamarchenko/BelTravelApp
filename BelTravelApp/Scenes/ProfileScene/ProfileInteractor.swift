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
	func setFinishTrip(request: Profile.Something.Request)
	func setUpcomingTrip(request: Profile.Something.Request)
	func loadTrips(request: Profile.Something.Request)
}

protocol ProfileDataStore {
	var finishedTrip: NewTrip? { get set }
	var upcomingTrip: NewTrip? { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
	var presenter: ProfilePresentationLogic?
	var worker: ProfileWorker?
	var finishedTrip: NewTrip?
	var upcomingTrip: NewTrip?
	
	// MARK: Do something
	
	func loadInformation(request: Profile.Something.Request) {
		worker = ProfileWorker()
		worker?.doSomeWork()
		
		FirebaseDatabaseManager.shered.fetchUser(otherUser: nil) { [weak self] user in
			let response = Profile.Something.Response(person: user, image: user.image)
			self?.presenter?.presentUserInformation(response: response)
		}
	}
	
	func loadTrips(request: Profile.Something.Request) {
		worker = ProfileWorker()
		worker?.doSomeWork()
		FirebaseDatabaseManager.shered.fetchUserTrips(document: nil) { [weak self] upcomingTrips, finishedTrips in
			let response = Profile.Something.Response(upcomingTrips: upcomingTrips, finishedTrips: finishedTrips)
			self?.presenter?.presenTripsInformation(response: response)
		}
	}
	
	func saveImageInDatabase(request: Profile.Something.Request) {
		if let data = request.image?.pngData() {
			guard let name = request.name else {
				return
			}
			FirebaseDatabaseManager().uploadImageData(data: data, serverFileName: "\(name).png", folder: "PhotosOfUser") { [weak self] (isSuccess, url) in
				print("uploadImageData: \(isSuccess), \(url!)")
				let response = Profile.Something.Response(image: request.image)
				self?.presenter?.presentNewSavedPhoto(response: response)
			}
		}
	}
	
	func setFinishTrip(request: Profile.Something.Request) {
		finishedTrip = request.finishedTrip
		self.presenter?.presentFinishedTrip()
	}
	
	func setUpcomingTrip(request: Profile.Something.Request) {
		upcomingTrip = request.upcomingTrip
		self.presenter?.presentUpcomingTrip()
	}
	
}
