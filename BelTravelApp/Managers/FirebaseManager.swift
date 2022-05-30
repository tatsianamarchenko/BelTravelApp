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
	private let db = Firestore.firestore()

	private func getSingleLocation(snapshot: DocumentSnapshot, complition: @escaping (Location)-> Void) {

		guard let data = snapshot.data() else {
			print("No documents")
			return
		}

		let wantToVisit = [FullInformationAppUser]()
		//let	data = snapshot.data()
		let	documentPath = snapshot.reference.path
		let coordinats = data["coordinats"] as? GeoPoint
		guard let coordinats = coordinats else {
			return
		}
		let lat = coordinats.latitude
		let lon = coordinats.longitude
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
				let location = Location(lat: lat, lng: lon, description: description, image: image, name: name, type: type, firebasePath: documentPath, wantToVisit: wantToVisit, isPopular: isPopular, locationWhoLiked: snapshot.reference.documentID, region: region)
				complition(location)
			}
		}
	}

	public func fetchLocationData(collection: String, complition: @escaping ([Location])-> Void) {
		db.collection(collection).getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var result = [Location]()
			documents.map { [weak self] queryDocumentSnapshot in
				self?.getSingleLocation(snapshot: queryDocumentSnapshot) { location in
					result.append(location)
					complition(result)
				}
			}
		}
	}
	
	public func addUserToDatabase(with userInformation: FullInformationAppUser, id: String) {
		db.collection("users").document(id).setData([
			"email": userInformation.email,
			"name": userInformation.name,
			"lastName": userInformation.lastName,
			"defaultLocation": userInformation.defaultLocation
		])
	}
	
	public func addFavoriteToDatabase(location: Location, complition: @escaping(Bool)-> Void) {
		db.collection("users").document("\(Auth.auth().currentUser?.uid ?? "")").collection("Favorite").addDocument(data: ["favorite":  location.firebasePath]) { [weak self] error in
			if error == nil {
				self?.db.document(location.firebasePath).collection("FavoriteByUsers").addDocument(data: ["favorite" : "\(Auth.auth().currentUser?.uid ?? "")"])
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
		db.collection("users").document("\(user)").updateData([
			"ref": fileRef.fullPath
		])
		_ = fileRef.putData(data, metadata: nil) { metadata, error in
			fileRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					completionHandler(false, nil)
					return
				}
				completionHandler(true, downloadURL.absoluteString)
			}
		}
	}

	public func saveImages(tripInformation: NewTrip, data: Data, serverFileName: String, folder: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
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
		db.collection("\(tripInformation.region)Trips").document(document).collection("photos").document().setData(["ref": fileRef.fullPath])

		_ = fileRef.putData(data, metadata: nil) { metadata, error in
			fileRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					completionHandler(false, nil)
					return
				}
				completionHandler(true, downloadURL.absoluteString)
			}
		}
	}

	public func fetchSavedImages(tripInformation: NewTrip, completionHandler: @escaping ([UIImage]?) -> Void) {
		guard let document = tripInformation.document else {
			return
		}
		db.collection("\(tripInformation.region)Trips").document(document).collection("photos").getDocuments {(querySnapshot, error) in

			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var images = [UIImage]()
			documents.map { queryDocumentSnapshot in

				let	data = queryDocumentSnapshot.data()
				let path = data["ref"] as? String ?? ""
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
		db.collection("users").document(user).getDocument {(querySnapshot, error) in
			let	data = querySnapshot?.data()
			let path = data?["ref"] as? String ?? ""
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
	
	public func fetchFavoriteData(complition: @escaping ([Location])-> Void) {
		var result = [Location]()
		db.collection("users").document("\(Auth.auth().currentUser?.uid ?? "")").collection("Favorite").getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			documents.map { queryDocumentSnapshot in
				let wantToVisit = [FullInformationAppUser]()
				let	data = queryDocumentSnapshot.data()
				let path = data["favorite"] as? String ?? ""
				self.db.document(path).getDocument { (querySnapshot, error) in
					guard let querySnapshot = querySnapshot else {return}
					self.getSingleLocation(snapshot: querySnapshot) { location in
						result.append(location)
						complition(result)
					}
				}
			}
		}
	}
	
	public func fetchUser(otherUser: String?, complition: @escaping (FullInformationAppUser)-> Void) {
		var user = Auth.auth().currentUser?.uid ?? ""
		if otherUser != nil {
			user = otherUser!
		}
		db.collection("users").document(user).getDocument { (querySnapshot, error) in
			guard let data = querySnapshot?.data() else {
				print("No document")
				return
			}
			var image: UIImage?
			let email = data["email"] as? String ?? ""
			let name = data["name"] as? String ?? ""
			let lastName = data["lastName"] as? String ?? ""
			let defaultLocation = data["defaultLocation"] as? String ?? ""
			let path = data["ref"] as? String ?? ""
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

	public func addNewTripToDatabase(with tripInformation: NewTrip, complition: @escaping (Bool)-> Void) {
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		let path = db.collection("\(tripInformation.region)Trips").document()
		path.collection("participants").document("\(Auth.auth().currentUser?.uid ?? "")").setData(["participant" : Auth.auth().currentUser?.uid as Any])
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
				self.db.collection("users").document(user).collection("TripsByUser").document(path.documentID).setData( ["ref" : path])
				complition(true)
			} else {
				complition(false)
			}
		}
	}
	
	public func addParticipantInTrip(with tripInformation: NewTrip, complition: @escaping (Bool)-> Void) {
		guard let document = tripInformation.document else {
			return
		}
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		let path = db.collection("\(tripInformation.region)Trips").document(document)
		path.collection("participants").document(user).setData(["participant" : user as Any])

		self.db.collection("users").document(user).collection("TripsByUser").document(document).setData( ["ref" : path])
	}

	public func deleteParticipantFromTrip(with tripInformation: NewTrip, complition: @escaping (Error?)-> Void) {
		guard let document = tripInformation.document else {
			return
		}
		guard let user = Auth.auth().currentUser?.uid else {
			return
		}
		db.collection("\(tripInformation.region)Trips").document(document).collection("participants").document(user).delete { error in
			if error == nil {
				self.db.collection("users").document(user).collection("TripsByUser").document(document).delete { error in
					complition(error)
				}
			}
		}
	}

	private func fetchSingleTrip(snapshot: DocumentSnapshot, complition: @escaping (NewTrip)-> Void) {
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
		self.db.document(locationPath).getDocument { documentSnapshot, error in
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
					let location = NewTrip(locationPath: locationPath, document: snapshot.documentID, locationName: locationName, time: time, maxPeople: numberOfPeople, description: description, creator: creator, region: region, image: image, participants: nil, locationOfParticipants: snapshot.reference.documentID, isActive: isActive)
					complition(location)
				}
			}
		}
	}
	
	public func fetchCreatedTrips(collection: String, complition: @escaping ([NewTrip])-> Void) {
		var result = [NewTrip]()
		self.db.collection("\(collection)Trips").addSnapshotListener { (querySnapshot, error) in
			querySnapshot?.documents.map { queryDocumentSnapshot in
				self.fetchSingleTrip(snapshot: queryDocumentSnapshot) { location in
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
		db.collection("\(tripInformation.region)Trips").document(document).updateData(["isActive": false as Bool])
	}
	
	public func fetchParticipants(collection: String, document: String, secondCollection: String, field: String, complition: @escaping ([FullInformationAppUser])-> Void) {
		var participants = [FullInformationAppUser]()
		self.db.collection(collection).document(document).collection(secondCollection).addSnapshotListener { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			documents.map { queryDocumentSnapshot in
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

	public func fetchUserTrips(document: FullInformationAppUser?, complition: @escaping ([NewTrip], [NewTrip])-> Void) {
		var user = Auth.auth().currentUser?.uid
		if document != nil {
			user = document?.document
		}
		var upcomingTrips = [NewTrip]()
		var finishedTrips = [NewTrip]()
		db.collection("users").document(user ?? "").collection("TripsByUser").addSnapshotListener { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			documents.map { queryDocumentSnapshot in
				upcomingTrips.removeAll()
				finishedTrips.removeAll()
				let	data = queryDocumentSnapshot.data()
				let pathDoc = data["ref"] as? DocumentReference
				guard let path = pathDoc?.path else {
					return
				}
				self.db.document(path).addSnapshotListener { (querySnapshot, error) in
					self.fetchSingleTrip(snapshot: querySnapshot!) { location in
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

	func getAllMesages(tripInformation: NewTrip, complition : @escaping ([Message])->()) {
		guard let document = tripInformation.document else {
			return
		}
		db.collection("\(tripInformation.region)Trips").document(document).collection("messages").getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var messageRecived = [Message]()
			documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let messageText = data["message"] as? String ?? ""
				let sender = data["sender"] as? String ?? ""
				let stamp = data["data"] as? Timestamp
				let date = stamp?.dateValue() ?? Date()

				let message = Message(sender: Sender(senderId: sender, displayName: "-"), messageId: queryDocumentSnapshot.documentID, sentDate: date, kind: .text(messageText))
				messageRecived.append(message)
			}
			complition(messageRecived)
		}
	}

	func sendMessage(tripInformation: NewTrip, message: Message, messageText: String, complition : @escaping (Bool)->()) {
		guard let document = tripInformation.document else {
			return
		}
		let path = db.collection("\(tripInformation.region)Trips").document(document)
		path.collection("messages").addDocument(data: [
			"data" : Date(),
			"sender" : message.sender.senderId,
			"message" : messageText ]) { error in
				if error == nil {
					complition(true)
				} else {
					complition(false)
				}
			}
	}
}
