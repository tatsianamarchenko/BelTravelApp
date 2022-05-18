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
				let	data = queryDocumentSnapshot.data()
				let	documentPath = queryDocumentSnapshot.reference.path
				var image: UIImage?
				let coordinats = data["coordinats"] as? String ?? ""
				let description = data["description"] as? String ?? ""
				let name = data["name"] as? String ?? ""
				let type = data["type"] as? String ?? ""
				let path = data["image"] as? String ?? ""
				let storage = Storage.storage().reference()
				let fileRef = storage.child(path)
				fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
					if error == nil {
						guard let data = data else {
							return
						}

						image = UIImage(data: data)
						let location = Location(coordinats: coordinats, description: description, image: image!, name: name, type: type, firebasePath: documentPath)
						result.append(location)
						complition(result)
					}

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

		db.collection("users").document("\(Auth.auth().currentUser?.uid ?? "")").collection("Favorite").addDocument(data: ["favorite":  location.firebasePath]) { error in
			if error == nil {
				complition(true)
			} else {
				complition(false)
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
				let	data = queryDocumentSnapshot.data()
				let path = data["favorite"] as? String ?? ""
				self.db.document(path).getDocument { (querySnapshot, error) in
					guard let data = querySnapshot?.data() else {
						print("No documents")
						return
					}
					let	documentPath = path
					var image: UIImage?
					let coordinats = data["coordinats"] as? String ?? ""
					let description = data["description"] as? String ?? ""
					let name = data["name"] as? String ?? ""
					let type = data["type"] as? String ?? ""
					let path = data["image"] as? String ?? ""
					let storage = Storage.storage().reference()
					let fileRef = storage.child(path)
					fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
						if error == nil {
							guard let data = data else {
								return
							}
							image = UIImage(data: data)
							let location = Location(coordinats: coordinats, description: description, image: image!, name: name, type: type, firebasePath: documentPath)
							result.append(location)

						}
						print(result.count)
						complition(result)
					}
				}
			}
		}
	}
	
	public func fetchUser(complition: @escaping (FirebaseAuthManager.FullInformationAppUser)-> Void) {
		db.collection("users").document("\(Auth.auth().currentUser?.uid ?? "")").getDocument(completion: { (querySnapshot, error) in
			guard let data = querySnapshot?.data() else {
				print("No document")
				return
			}
			var image: UIImage?
			let email = data["email"] as? String ?? ""
			let name = data["name"] as? String ?? ""
			let lastName = data["lastName"] as? String ?? ""
			let defaultLocation = data["defaultLocation"] as? String ?? ""
			let path = data["image"] as? String ?? ""
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
		})
	}
}
