//
//  RegistrationInteractor.swift
//  Messenger
//
//  Created by Tatsiana Marchanka on 2.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import FirebaseAuth

protocol RegistrationBusinessLogic
{
  func createNewUser(request: Registration.Something.Request)
}

protocol RegistrationDataStore
{
  //var name: String { get set }
}

class RegistrationInteractor: RegistrationBusinessLogic, RegistrationDataStore
{
  var presenter: RegistrationPresentationLogic?
  var worker: RegistrationWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func createNewUser(request: Registration.Something.Request)
  {
//    worker = RegistrationWorker()
//    worker?.doSomeWork()
	  FirebaseAuthManager.shered.insertNewUser(with: FirebaseAuthManager.AppUser(email: request.email, passward: request.passward)) { [weak self] error in
		  if error == nil {
			  if Auth.auth().currentUser != nil {
				  let response = Registration.Something.Response()
				  self?.presenter?.presentAuthorized(response: response)
//				  let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessengerTabBarViewController")
//				  startVC.modalPresentationStyle = .fullScreen
//				  self?.present(startVC, animated: false)
			  }
		  }
	  }
  }
}