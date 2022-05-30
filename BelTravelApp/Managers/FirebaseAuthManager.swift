//
//  FirebaseAuthManager.swift
//  OnlineShop
//
//  Created by Tatsiana Marchanka on 13.04.22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
	static let shered = FirebaseAuthManager()
	public func insertNewUser(with user: AppUserAuthorization, fullInformationAboutUser: FullInformationAppUser, completion: @escaping (Error?) -> Void) {
		Auth.auth().createUser(withEmail: user.email, password: user.passward) { authResult, error in
			if  error != nil {
				guard let error = error else {
					return
				}
				completion(error)
			}
			else {
				if authResult != nil {
					guard let id = authResult?.user.uid else {
						return
					}
					Auth.auth().signIn(withEmail: user.email, password: user.passward)
					FirebaseDatabaseManager.shered.addUserToDatabase(with: fullInformationAboutUser, id: id)
					completion(nil)
				}
			}
		}
	}

	public func enterUser(with user: AppUserAuthorization, completion: @escaping((Result<(), Error>) -> Void)) {
		Auth.auth().signIn(withEmail: user.email, password: user.passward) { authResult, error in
			if  error != nil {
				guard let error = error else {
					return
				}
				completion(.failure(error))
			}
			else {
				completion(.success(()))
			}
		}
	}

	public func signOut (completion: @escaping(() -> Void)) {
		do {
			try Auth.auth().signOut()
			completion()
		} catch let error {
			print(error)
		}
	}

	struct AppUserAuthorization {
		let email: String
		let passward: String
	}
}
