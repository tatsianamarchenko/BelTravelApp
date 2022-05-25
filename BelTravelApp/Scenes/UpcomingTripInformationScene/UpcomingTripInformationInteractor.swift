//
//  UpcomingTripInformationInteractor.swift
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

protocol UpcomingTripInformationBusinessLogic
{
  func loadUsers(request: UpcomingTripInformation.Something.Request)
}

protocol UpcomingTripInformationDataStore
{
  var newTrip: NewTrip? { get set }
}

class UpcomingTripInformationInteractor: UpcomingTripInformationBusinessLogic, UpcomingTripInformationDataStore
{
  var presenter: UpcomingTripInformationPresentationLogic?
  var worker: UpcomingTripInformationWorker?
  var newTrip: NewTrip?
  
  // MARK: Do something
  
  func loadUsers(request: UpcomingTripInformation.Something.Request)
  {
    worker = UpcomingTripInformationWorker()
    worker?.doSomeWork()

	  FirebaseDatabaseManager.shered.fetchParticipants(collection: "\(request.trip.region)Trips", document: "\(request.trip.locationOfParticipants)", secondCollection: "participants", field: "participant") { [weak self] users in
		  let response = UpcomingTripInformation.Something.Response(users: users)
		  self?.presenter?.presentParticipants(response: response)
	  }
  }
}
