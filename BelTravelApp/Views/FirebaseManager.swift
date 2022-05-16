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
						let location = Location(coordinats: coordinats, description: description, image: image!, name: name, type: type)
						result.append(location)
						complition(result)
					}

				}
			}
		}
	}

	public func fetchImage(collection: String, imageView: UIImageView) {
		db.collection(collection).getDocuments { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let path = data["image"] as? String ?? ""
				let storage = Storage.storage().reference()
				let fileRef = storage.child(path)
				fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
					if error == nil {
						guard let data = data else {
							return
						}
						imageView.image = UIImage(data: data)!
					}
				}
			}
		}
	}
}
