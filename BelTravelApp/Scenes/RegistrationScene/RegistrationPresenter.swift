//
//  RegistrationPresenter.swift
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

protocol RegistrationPresentationLogic {
  func presentAuthorized(response: Registration.Something.Response)
}

class RegistrationPresenter: RegistrationPresentationLogic {
  weak var viewController: RegistrationDisplayLogic?
  
  // MARK: Do something
  
  func presentAuthorized(response: Registration.Something.Response) {
    let viewModel = Registration.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}