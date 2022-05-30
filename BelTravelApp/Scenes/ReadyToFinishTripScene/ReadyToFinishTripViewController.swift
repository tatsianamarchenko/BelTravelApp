//
//  ReadyToFinishTripViewController.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 28.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReadyToFinishTripDisplayLogic: class {
	func displayResult(viewModel: ReadyToFinishTrip.Something.ViewModel)
	func displayParticipants(viewModel: ReadyToFinishTrip.Something.ViewModel)
	func displayUserViewController()
}

class ReadyToFinishTripViewController: UIViewController, ReadyToFinishTripDisplayLogic {
	var interactor: ReadyToFinishTripBusinessLogic?
	var router: (NSObjectProtocol & ReadyToFinishTripRoutingLogic & ReadyToFinishTripDataPassing)?
	
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
		let interactor = ReadyToFinishTripInteractor()
		let presenter = ReadyToFinishTripPresenter()
		let router = ReadyToFinishTripRouter()
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
		timeLable.text = trip?.time
		title = trip?.locationName
		tripImage.image = UIImage(named: "back1")
		makeParticipantsCollection()
		loadParticipants()
	}
	
	// MARK: Do something
	var participantsArray = [FullInformationAppUser]()
	var trip: NewTrip?
	@IBOutlet weak var tripImage: UIImageView!
	@IBOutlet weak var timeLable: UILabel!
	@IBOutlet weak var participantsCollection: UICollectionView!
	@IBOutlet weak var noParticipants: UILabel!
	
	
	@IBAction func finishTripAction(_ sender: Any) {
		router?.routeToSaveTripViewController()
	}
	
	@IBAction func dontWantToParticipateAction(_ sender: Any) {
		guard let trip = trip else {
			return
		}
		let request = ReadyToFinishTrip.Something.Request(trip: trip)
		interactor?.removeParticipant(request: request)
	}
	
	@IBAction func openChatAction(_ sender: Any) {
		router?.routeToChatViewController()
	}
	
	func makeParticipantsCollection () {
		participantsCollection.delegate = self
		participantsCollection.dataSource = self
		let nib = UINib(nibName: "ParticipantCollectionViewCell", bundle: nil)
		participantsCollection.register(nib, forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
	}
	
	func loadParticipants() {
		guard let trip = trip else {
			return
		}
		let request = ReadyToFinishTrip.Something.Request(trip: trip)
		interactor?.loadParticipants(request: request)
	}
	
	func displayParticipants(viewModel: ReadyToFinishTrip.Something.ViewModel) {
		guard let users = viewModel.participants else {
			return
		}
		participantsArray = users
		participantsCollection.reloadData()
	}
	
	func displayResult(viewModel: ReadyToFinishTrip.Something.ViewModel) {
		if viewModel.result == nil {
			router?.routeToProfileViewController(source: self)
		}
		else {
			print(viewModel.result)
		}
	}
	
	func displayUserViewController() {
		router?.routeToUserViewController()
	}
}

extension ReadyToFinishTripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return participantsArray.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if !participantsArray.isEmpty {
			noParticipants.isHidden = true
		}
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																ParticipantCollectionViewCell.identifier, for: indexPath)
				as? ParticipantCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		cell.config(model: participantsArray[indexPath.row])
		cell.layer.borderWidth = 0
		cell.layer.shadowColor = UIColor.systemGray.cgColor
		cell.layer.shadowOffset = CGSize(width: 0.3, height: 0)
		cell.layer.shadowRadius = 3
		cell.layer.shadowOpacity = 0.5
		cell.layer.cornerRadius = 15
		cell.layer.masksToBounds = false
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 250, height: 100)
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 120)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let request = ReadyToFinishTrip.Something.Request(user: participantsArray[indexPath.row])
		interactor?.setUser(request: request)
	}
}
