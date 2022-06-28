//
//  FirebaseManager.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 16.05.22.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class FirebaseDatabaseManager {
	
	static let shered = FirebaseDatabaseManager()
	private let database = Firestore.firestore()

	private func getOneLocation(snapshot: DocumentSnapshot, complition: @escaping (Location) -> Void) {

		guard let data = snapshot.data() else {
			print("No documents")
			return
		}

		let whoWantToVisit = [FullInformationAppUser]()
		let	documentPath = snapshot.reference.path
		let coordinats = data["coordinats"] as? GeoPoint
		guard let coordinats = coordinats else {
			return
		}
		let lat = coordinats.latitude
		let lng = coordinats.longitude
		let description = data["description"] as? String ?? ""
		let name = data["name"] as? String ?? ""
		let type = data["type"] as? String ?? ""
		let path = data["image"] as? String ?? ""
		let isPopular = data["IsPopular"] as? Bool ?? false
		let region = data["region"] as? String ?? ""
		let storage = Storage.storage().reference()
		let fileRef = storage.child(path)
		fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
			if error == nil {
				guard let data = data else {
					return
				}

				guard let image = UIImage(data: data) else {
					return
				}
				let location = Location(lat: lat,
										lng: lng,
										description: description,
										image: image,
										name: name,
										type: type,
										firebasePath: documentPath,
										wantToVisit: whoWantToVisit,
										isPopular: isPopular,
										locationWhoLiked: snapshot.reference.documentID,
										region: region)
				complition(location)
			}
		}
	}

	public func fetchLocationData(collection: String, complition: @escaping ([Location]) -> Void) {
		database.collection(collection).getDocuments { (querySnapshot, _) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var result = [Location]()
			_ = documents.map { [weak self] queryDocumentSnapshot in
				self?.getOneLocation(snapshot: queryDocumentSnapshot) { location in
					result.append(location)
					complition(result)
				}
			}
		}
	}
	
	public func addUserToDatabase(with userInformation: FullInformationAppUser, id: String) {
		database.collection(Constants.share.userCollection).document(id).setData([
			"email": userInformation.email,
			"name": userInformation.name,
			"lastName": userInformation.lastName,
			"defaultLocation": userInformation.defaultLocation
		])
	}
	
	public func addFavoriteToDatabase(location: Location, complition: @escaping(Bool) -> Void) {
		database.collection(Constants.share.userCollection).document("\(Auth.auth().currentUser?.uid ?? "")")
			.collection(Constants.share.favoriteCollection).addDocument(data: [Constants.share.favoriteField: location.firebasePath]) { [weak self] error in
			if error == nil {
				self?.database.document(location.firebasePath).collection(Constants.share.favoriteByUsersCollection).addDocument(data: [Constants.share.favoriteField: "\(Auth.auth().currentUser?.uid ?? "")"])
				complition(true)
			} else {
				complition(false)
			}
		}
	}

	public func uploadImageData(data: Data, serverFileName: String, folder: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
		let storage = Storage.storage()
		let storageRef = storage.reference()
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		let directory = "\(folder)/\(user)/"
		let fileRef = storageRef.child(directory + serverFileName)
		database.collection(Constants.share.userCollection).document("\(user)").updateData([
			Constants.share.referenceField: fileRef.fullPath
		])
		_ = fileRef.putData(data, metadata: nil) { _, _ in
			fileRef.downloadURL { (url, _) in
				guard let downloadURL = url else {
					completionHandler(false, nil)
					return
				}
				completionHandler(true, downloadURL.absoluteString)
			}
		}
	}

	public func saveImages(tripInformation: NewTrip, data: Data, serverFileName: String, folder: String,
						   completionHandler: @escaping (_ isSuccess: Bool) -> Void) {
		let storage = Storage.storage()
		let storageRef = storage.reference()
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		guard let document = tripInformation.document else {
			return
		}
		let directory = "\(folder)/\(user)/"
		let fileRef = storageRef.child(directory + serverFileName)
		database.collection("\(tripInformation.region)Trips").document(document).collection(Constants.share.photosCollection).document().setData([Constants.share.referenceField: fileRef.fullPath])

		_ = fileRef.putData(data, metadata: nil) { _, _ in
			fileRef.downloadURL { (url, _) in
				guard let _ = url else {
					completionHandler(false)
					return
				}
				completionHandler(true)
			}
		}
	}

	public func fetchSavedImages(tripInformation: NewTrip, completionHandler: @escaping ([UIImage]?) -> Void) {
		guard let document = tripInformation.document else {
			return
		}
		database.collection("\(tripInformation.region)Trips").document(document).collection(Constants.share.photosCollection).getDocuments {(querySnapshot, error) in

			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var images = [UIImage]()
			_ =	documents.map { queryDocumentSnapshot in

				let	data = queryDocumentSnapshot.data()
				let path = data[Constants.share.referenceField] as? String ?? ""
				let storage = Storage.storage().reference()
				let fileRef = storage.child(path)
				fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
					if error == nil {
						guard let data = data else {
							return
						}
						let image = UIImage(data: data)
						guard let image = image else {return}
						images.append(image)
						completionHandler(images)
					}
				}
			}
		}
	}

	public func fetchImageData(completionHandler: @escaping (UIImage?) -> Void) {
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		database.collection(Constants.share.userCollection).document(user).getDocument {(querySnapshot, error) in
			let	data = querySnapshot?.data()
			let path = data?[Constants.share.referenceField] as? String ?? ""
			let storage = Storage.storage().reference()
			let fileRef = storage.child(path)
			fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
				if error == nil {
					guard let data = data else {
						return
					}
					let image = UIImage(data: data)
					guard let image = image else {return}
					completionHandler(image)
				}
			}
		}
	}
	
	public func fetchFavoriteData(complition: @escaping ([Location]) -> Void) {
		var result = [Location]()
		database.collection(Constants.share.userCollection).document("\(Auth.auth().currentUser?.uid ?? "")").collection(Constants.share.favoriteCollection).getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			_ = documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let path = data[Constants.share.favoriteField] as? String ?? ""
				self.database.document(path).getDocument { (querySnapshot, _) in
					guard let querySnapshot = querySnapshot else {return}
					self.getOneLocation(snapshot: querySnapshot) { location in
						result.append(location)
						complition(result)
					}
				}
			}
		}
	}
	
	public func fetchUser(otherUser: String?, complition: @escaping (FullInformationAppUser) -> Void) {
		var user = Auth.auth().currentUser?.uid ?? ""
		if otherUser != nil {
			user = otherUser!
		}
		database.collection(Constants.share.userCollection).document(user).getDocument { (querySnapshot, error) in
			guard let data = querySnapshot?.data() else {
				print("No document")
				return
			}
			var image: UIImage?
			let email = data["email"] as? String ?? ""
			let name = data["name"] as? String ?? ""
			let lastName = data["lastName"] as? String ?? ""
			let defaultLocation = data["defaultLocation"] as? String ?? ""
			let path = data[Constants.share.referenceField] as? String ?? ""
			guard let document = Auth.auth().currentUser?.uid else {
				return
			}
			let storage = Storage.storage().reference()
			let fileRef = storage.child(path)
			fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
				if error == nil {
					guard let data = data else {
						return
					}
					image = UIImage(data: data)
					let user = FullInformationAppUser(email: email, name: name, lastName: lastName, defaultLocation: defaultLocation, image: image, document: document)
					complition(user)
				}
			}
		}
	}

	public func addNewTripToDatabase(with tripInformation: NewTrip, complition: @escaping (Bool) -> Void) {
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		let path = database.collection("\(tripInformation.region)Trips").document()
		path.collection(Constants.share.participantsCollection).document("\(Auth.auth().currentUser?.uid ?? "")").setData(["participant": Auth.auth().currentUser?.uid as Any])
		path.setData([
			"locationPath": tripInformation.locationPath,
			"locationName": tripInformation.locationName,
			"time": tripInformation.time,
			"numberOfPeople": tripInformation.maxPeople,
			"description": tripInformation.description,
			"region": tripInformation.region,
			"isActive": true as Bool
		]) { error in
			if error == nil {
				self.database.collection(Constants.share.userCollection).document(user).collection(Constants.share.userTripsCollection).document(path.documentID).setData([Constants.share.referenceField: path])
				complition(true)
			} else {
				complition(false)
			}
		}
	}
	
	public func addParticipantInTrip(with tripInformation: NewTrip) {
		guard let document = tripInformation.document else {
			return
		}
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		let path = database.collection("\(tripInformation.region)Trips").document(document)
		path.collection(Constants.share.participantsCollection).document(user).setData(["participant": user as Any])

		self.database.collection(Constants.share.userCollection).document(user).collection(Constants.share.userTripsCollection).document(document).setData( [Constants.share.referenceField: path])
	}

	public func deleteParticipantFromTrip(with tripInformation: NewTrip, complition: @escaping (Error?) -> Void) {
		guard let document = tripInformation.document else {
			return
		}
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		database.collection("\(tripInformation.region)Trips").document(document).collection(Constants.share.participantsCollection).document(user).delete { error in
			if error == nil {
				self.database.collection(Constants.share.userCollection).document(user).collection(Constants.share.userTripsCollection).document(document).delete { error in
					complition(error)
				}
			}
		}
	}

	private func fetchOneTrip(snapshot: DocumentSnapshot, complition: @escaping (NewTrip) -> Void) {
		guard let data = snapshot.data() else {
			print("No documents")
			return
		}
		let locationPath = data["locationPath"] as? String ?? ""
		let locationName = data["locationName"] as? String ?? ""
		let creator = data["creator"] as? String ?? ""
		let description = data["description"] as? String ?? ""
		let numberOfPeople = data["numberOfPeople"] as? String ?? ""
		let time = data["time"] as? String ?? ""
		let region = data["region"] as? String ?? ""
		let isActive = data["isActive"] as? Bool ?? true
		self.database.document(locationPath).getDocument { documentSnapshot, error in
			let	data = documentSnapshot?.data()
			let path = data?["image"] as? String ?? ""
			let storage = Storage.storage().reference()
			let fileRef = storage.child(path)
			fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
				if error == nil {
					guard let data = data else {
						return
					}
					guard let image = UIImage(data: data) else {
						return
					}
					let location = NewTrip(locationPath: locationPath,
										   document: snapshot.documentID,
										   locationName: locationName,
										   time: time,
										   maxPeople: numberOfPeople,
										   description: description,
										   creator: creator,
										   region: region,
										   image: image,
										   participants: nil,
										   locationOfParticipants: snapshot.reference.documentID,
										   isActive: isActive)
					complition(location)
				}
			}
		}
	}
	
	public func fetchCreatedTrips(collection: String, complition: @escaping ([NewTrip]) -> Void) {
		var result = [NewTrip]()
		self.database.collection("\(collection)Trips").addSnapshotListener { (querySnapshot, _) in
			_ = querySnapshot?.documents.map { queryDocumentSnapshot in
				self.fetchOneTrip(snapshot: queryDocumentSnapshot) { location in
					if location.isActive == true {
						result.append(location)
						complition(result)
					}
				}
			}
		}
	}

	public func finishTrip(with tripInformation: NewTrip) {
		guard let document = tripInformation.document else {
			return
		}
		database.collection("\(tripInformation.region)Trips").document(document).updateData(["isActive": false as Bool])
	}
	
	public func fetchParticipants(collection: String, document: String, secondCollection: String, field: String, complition: @escaping ([FullInformationAppUser]) -> Void) {
		var participants = [FullInformationAppUser]()
		self.database.collection(collection).document(document).collection(secondCollection).addSnapshotListener { (querySnapshot, _) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			_ = documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let participant = data[field] as? String ?? ""
				participants.removeAll()
				self.fetchUser(otherUser: participant) { user in
					participants.append(user)
					complition(participants)
				}
			}
		}
	}

	public func fetchUserTrips(document: FullInformationAppUser?, complition: @escaping ([NewTrip], [NewTrip]) -> Void) {
		var user = Auth.auth().currentUser?.uid
		if document != nil {
			user = document?.document
		}
		var upcomingTrips = [NewTrip]()
		var finishedTrips = [NewTrip]()
		database.collection(Constants.share.userCollection).document(user ?? "").collection(Constants.share.userTripsCollection).addSnapshotListener { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			_ = documents.map { queryDocumentSnapshot in
				upcomingTrips.removeAll()
				finishedTrips.removeAll()
				let	data = queryDocumentSnapshot.data()
				let pathDoc = data[Constants.share.referenceField] as? DocumentReference
				guard let path = pathDoc?.path else {
					return
				}
				self.database.document(path).addSnapshotListener { (querySnapshot, _) in
					self.fetchOneTrip(snapshot: querySnapshot!) { location in
						if location.isActive == true {
							upcomingTrips.append(location) } else {
								finishedTrips.append(location)
							}
						complition(upcomingTrips, finishedTrips)
					}
				}
			}
		}
	}
}
