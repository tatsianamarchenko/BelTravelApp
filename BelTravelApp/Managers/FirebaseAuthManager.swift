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
	public func insertNewUser(with user: AppUser,  completion: @escaping (Error?) -> Void) {
		Auth.auth().createUser(withEmail: user.email, password: user.passward) { authResult, error in
			if  error != nil {
				completion(error!)
			}
			else {
				if authResult != nil {
					Auth.auth().signIn(withEmail: user.email, password: user.passward)
				//	self.firebaseManager.addUserToDatabase(with: user, id: (authResult?.user.uid)!)
				//UserDefaults.standard.set(true, forKey: "isAuthorized")
				completion(nil)
				}
			}
		}
	}

	public func enterUser(with user: AppUser, completion: @escaping((Result<(), Error>) -> Void)) {
		Auth.auth().signIn(withEmail: user.email, password: user.passward) { authResult, error in
			if  error != nil {
				completion(.failure(error!))
			}
			else {
				UserDefaults.standard.set(true, forKey: "isAuthorized")
				completion(.success(()))
			}
		}
	}

	public func signOut (completion: @escaping(() -> Void)) {
		do {
			try Auth.auth().signOut()
			UserDefaults.standard.removeObject(forKey: "isAuthorized")
			completion()
		} catch let error {
			print(error)
		}
	}

	struct AppUser {
		   let email: String
		   let passward: String
	   }
}
