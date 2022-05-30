//
//  CreateTripViewController.swift
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

protocol CreateTripDisplayLogic: AnyObject {
	func displayResult(viewModel: CreateTrip.Something.ViewModel)
}

class CreateTripViewController: UIViewController, CreateTripDisplayLogic {
	var interactor: CreateTripBusinessLogic?
	var router: (NSObjectProtocol & CreateTripRoutingLogic & CreateTripDataPassing)?
	var location: Location?
	var region: String?
	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: Setup

	private func setup() {
		let viewController = self
		let interactor = CreateTripInteractor()
		let presenter = CreateTripPresenter()
		let router = CreateTripRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	// MARK: Routing

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		titleLable.title = location?.name
		locationImage.image = location?.image
	}

	// MARK: Do something

	@IBOutlet weak var titleLable: UINavigationItem!
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var timeTextField: UITextField!
	@IBOutlet weak var maxPeopleTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBAction func createTripAction(_ sender: Any) {
		guard let time = timeTextField.text else {
			return
		}
		guard let locationName = location?.name else {
			return
		}
		guard let maxPeople = maxPeopleTextField.text else {
			return
		}
		guard let description = descriptionTextField.text else {
			return
		}
		guard let region = region else {
			return
		}
		if !time.isEmpty &&  !maxPeople.isEmpty &&  !description.isEmpty && !region.isEmpty {
			let request = CreateTrip.Something.Request(trip: NewTrip(locationPath: location?.firebasePath ?? "", document: nil, locationName: locationName, time: time, maxPeople: maxPeople, description: description, creator: nil, region: region, participants: nil, locationOfParticipants: "", isActive: true))
			interactor?.createNewTrip(request: request)
		}
	}

	func displayResult(viewModel: CreateTrip.Something.ViewModel) {
		router?.routeToMainViewController()
	}
}
