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
	
	public func fetchLocationData(collection: String, complition: @escaping ([Location])-> Void) {
		db.collection(collection).getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var result = [Location]()
			documents.map { queryDocumentSnapshot in
				var wantToVisit = [FirebaseAuthManager.FullInformationAppUser]()
				let	data = queryDocumentSnapshot.data()
				
				let	documentPath = queryDocumentSnapshot.reference.path
				var image = UIImage()
				let coordinats = data["coordinats"] as! GeoPoint
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
							print("location")
							return
						}
						
						image = UIImage(data: data)!
//						let location = Location(lat: lat, lng: lon, description: description, image: image!, name: name, type: type, firebasePath: documentPath, wantToVisit: wantToVisit, isPopular: isPopular, locationWhoLiked: queryDocumentSnapshot.reference.documentID, region: region)
//						result.append(location)
//						complition(result)
//						print(location)
					}

					let location = Location(lat: lat, lng: lon, description: description, image: image, name: name, type: type, firebasePath: documentPath, wantToVisit: wantToVisit, isPopular: isPopular, locationWhoLiked: queryDocumentSnapshot.reference.documentID, region: region)
					result.append(location)
					complition(result)
					print(location)
				}
			}
		}
	}
	
	public func addUserToDatabase(with userInformation: FirebaseAuthManager.FullInformationAppUser, id: String) {
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
	
	public func uploadImageData(data: Data, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
		let storage = Storage.storage()
		let storageRef = storage.reference()
		let directory = "PhotosOfUser/\(Auth.auth().currentUser!.uid)/"
		let fileRef = storageRef.child(directory + serverFileName)
		
		db.collection("users").document("\(Auth.auth().currentUser!.uid)").updateData([
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
	
	public func fetchImageData(completionHandler: @escaping (UIImage?) -> Void) {
		db.collection("users").document("\(Auth.auth().currentUser!.uid)").getDocument {(querySnapshot, error) in
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
				let wantToVisit = [FirebaseAuthManager.FullInformationAppUser]()
				let	data = queryDocumentSnapshot.data()
				let path = data["favorite"] as? String ?? ""
				self.db.document(path).getDocument { (querySnapshot, error) in
					guard let data = querySnapshot?.data() else {
						print("No documents")
						return
					}
					let	documentPath = path
					var image: UIImage?
					let coordinats = data["coordinats"] as! GeoPoint
					let lat = coordinats.latitude
					let lon = coordinats.longitude
					print(lat, lon)
					let description = data["description"] as? String ?? ""
					let name = data["name"] as? String ?? ""
					let type = data["type"] as? String ?? ""
					let isPopular = data["IsPopular"] as? Bool ?? false
					let region = data["region"] as? String ?? ""
					let path = data["image"] as? String ?? ""
					let storage = Storage.storage().reference()
					let fileRef = storage.child(path)
					fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
						if error == nil {
							guard let data = data else {
								return
							}
							image = UIImage(data: data)
							let location = Location(lat: lat, lng: lon, description: description, image: image!, name: name, type: type, firebasePath: documentPath, wantToVisit: wantToVisit, isPopular: isPopular, locationWhoLiked: querySnapshot!.documentID, region: region)
							result.append(location)
							
						}
						complition(result)
					}
				}
			}
		}
	}
	
	public func fetchUser(complition: @escaping (FirebaseAuthManager.FullInformationAppUser)-> Void) {
		db.collection("users").document("\(Auth.auth().currentUser?.uid ?? "")").getDocument { (querySnapshot, error) in
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
			let storage = Storage.storage().reference()
			let fileRef = storage.child(path)
			fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
				if error == nil {
					guard let data = data else {
						return
					}
					image = UIImage(data: data)
					let user = FirebaseAuthManager.FullInformationAppUser(email: email, name: name, lastName: lastName, defaultLocation: defaultLocation, image: image)
					complition(user)
				}
			}
		}
	}
	
	func fetchOtherUser(user: String, complition: @escaping (FirebaseAuthManager.FullInformationAppUser)-> Void) {
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
			let storage = Storage.storage().reference()
			let fileRef = storage.child(path)
			fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
				if error == nil {
					guard let data = data else {
						return
					}
					image = UIImage(data: data)
					let user = FirebaseAuthManager.FullInformationAppUser(email: email, name: name, lastName: lastName, defaultLocation: defaultLocation, image: image)
					complition(user)
				}
			}
		}
	}
	
	public func addNewTripToDatabase(with tripInformation: NewTrip, complition: @escaping (Bool)-> Void) {
		let path = db.collection("\(tripInformation.region)Trips").document()
		path.collection("participants").document().setData(["participant" : Auth.auth().currentUser?.uid as Any])
		path.setData([
			"locationPath": tripInformation.locationPath,
			"locationName": tripInformation.locationName,
			"time": tripInformation.time,
			"numberOfPeople": tripInformation.maxPeople,
			"description": tripInformation.description,
			"creator": Auth.auth().currentUser?.uid as Any,
			"region": tripInformation.region
		]) { error in
			if error == nil {
				self.db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("TripsByUser").addDocument(data: ["ref" : path])
				complition(true)
			} else {
				complition(false)
			}
		}
	}
	
	public func addParticipantInTrip(with tripInformation: NewTrip, complition: @escaping (Bool)-> Void) {
		let path = db.collection("\(tripInformation.region)Trips").document(tripInformation.document!)
		path.collection("participants").document().setData(["participant" : Auth.auth().currentUser?.uid as Any])
	}
	
	public func fetchCreatedTrips(collection: String, complition: @escaping ([NewTrip])-> Void) {
		var result = [NewTrip]()
		self.db.collection("\(collection)Trips").addSnapshotListener { (querySnapshot, error) in
			querySnapshot?.documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let locationPath = data["locationPath"] as? String ?? ""
				let locationName = data["locationName"] as? String ?? ""
				let creator = data["creator"] as? String ?? ""
				let description = data["description"] as? String ?? ""
				let numberOfPeople = data["numberOfPeople"] as? String ?? ""
				let time = data["time"] as? String ?? ""
				let region = data["region"] as? String ?? ""
				let location = NewTrip(locationPath: locationPath, document: queryDocumentSnapshot.documentID, locationName: locationName, time: time, maxPeople: numberOfPeople, description: description, creator: creator, region: region, participants: nil, locationOfParticipants: queryDocumentSnapshot.reference.documentID)
				result.append(location)
				complition(result)
			}
		}
	}
	
	public func fetchParticipants(collection: String, document: String, secondCollection: String, field: String, complition: @escaping ([FirebaseAuthManager.FullInformationAppUser])-> Void) {
		var participants = [FirebaseAuthManager.FullInformationAppUser]()
		self.db.collection(collection).document(document).collection(secondCollection).addSnapshotListener { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let participant = data[field] as? String ?? ""
				participants.removeAll()
				self.fetchOtherUser(user: participant) { user in
					participants.append(user)
					print(participants.count)
					complition(participants)

				}
			}
		}
	}

	func getAllMesages(chatId: String, complition : @escaping ([Message])->()) {
		db.collection("conversations").document(chatId).collection("messages").getDocuments { (querySnapshot, error) in
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

	func sendMessage(otherSenderId: String, conversationId: String, message: Message, messageText: String, complition : @escaping (Bool)->()) {
		if conversationId == nil {

		} else {
			db.collection("conversations").document(conversationId).collection("messages").addDocument(data: [
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
}

//	public func fetchImageData(completionHandler: @escaping ([UIImage]?) -> Void) {
   //		db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("AddedPhotosReferences").getDocuments { (querySnapshot, error) in
   //			guard let documents = querySnapshot?.documents else {
   //				print("No documents")
   //				return
   //			}
   //			var result = [UIImage]()
   //			documents.map { queryDocumentSnapshot in
   //				let	data = queryDocumentSnapshot.data()
   //				let path = data["ref"] as? String ?? ""
   //				let storage = Storage.storage().reference()
   //				let fileRef = storage.child(path)
   //				fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
   //					if error == nil {
   //						guard let data = data else {
   //							return
   //						}
   //
   //						let image = UIImage(data: data)
   //						guard let image = image else {return}
   //						result.append(image)
   //						completionHandler(result)
   //					}
   //				}
   //			}
   //		}
   //	}

