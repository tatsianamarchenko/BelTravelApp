//
//  SceneDelegate.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 10.05.22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		if Auth.auth().currentUser == nil {
			startWithoutAuthorization()
		} else {
			startAuthorized()
		}
	}

	private func startAuthorized() {
		let startVC = UIStoryboard(name: "Main",
								   bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
		window?.rootViewController = startVC
		window?.makeKeyAndVisible()
	}

	private func startWithoutAuthorization() {
		let startVC = UIStoryboard(name: "Main",
								   bundle: nil).instantiateViewController(withIdentifier: "SliderViewController")
		window?.rootViewController = startVC
		window?.makeKeyAndVisible()
	}

}
