//
//  SceneDelegate.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 10.05.22.
//

import UIKit
import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if Auth.auth().currentUser == nil {
			startWithoutAuthorization()
		} else {
			startAuthorized()
		}
	}

	func startAuthorized() {
		let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
		window?.rootViewController = startVC
		window?.makeKeyAndVisible()
	}

	func startWithoutAuthorization() {
		let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SliderViewController")
		window?.rootViewController = startVC
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
	}

	func sceneWillResignActive(_ scene: UIScene) {
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
	}

}

