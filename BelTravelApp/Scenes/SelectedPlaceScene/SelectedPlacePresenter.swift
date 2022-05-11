//
//  SelectedPlacePresenter.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 11.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectedPlacePresentationLogic
{
  func presentSomething(response: SelectedPlace.Something.Response)
}

class SelectedPlacePresenter: SelectedPlacePresentationLogic
{
  weak var viewController: SelectedPlaceDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: SelectedPlace.Something.Response)
  {
    let viewModel = SelectedPlace.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
