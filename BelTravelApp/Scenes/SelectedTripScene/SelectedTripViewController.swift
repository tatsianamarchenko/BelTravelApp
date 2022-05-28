//
//  SelectedTripViewController.swift
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

protocol SelectedTripDisplayLogic: class {
	func displayPhotos(viewModel: SelectedTrip.Something.ViewModel)
	func displayParticipants(viewModel: SelectedTrip.Something.ViewModel)
}

class SelectedTripViewController: UIViewController, SelectedTripDisplayLogic {
	var interactor: SelectedTripBusinessLogic?
	var router: (NSObjectProtocol & SelectedTripRoutingLogic & SelectedTripDataPassing)?

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
		let interactor = SelectedTripInteractor()
		let presenter = SelectedTripPresenter()
		let router = SelectedTripRouter()
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
		title = trip?.locationName
		loadPhotos()
		loadParticipants()
		makePhotosCollection()
		makeParticipantsCollection()
	}

	// MARK: Do something
	var trip: NewTrip?
	var photosArray = [UIImage]()
	var participantsArray = [FirebaseAuthManager.FullInformationAppUser]()

	@IBOutlet weak var participantsCollection: UICollectionView!
	@IBOutlet weak var photosCollection: UICollectionView!

	func loadPhotos() {
		guard let trip = trip else {
			return
		}
		let request = SelectedTrip.Something.Request(trip: trip)
		interactor?.loadPhotos(request: request)
	}

	func loadParticipants() {
		guard let trip = trip else {
			return
		}
		let request = SelectedTrip.Something.Request(trip: trip)
		interactor?.loadParticipants(request: request)
	}

	func displayPhotos(viewModel: SelectedTrip.Something.ViewModel) {
		guard let images = viewModel.images else {
			return
		}
		photosArray = images
		photosCollection.reloadData()
	}

	func displayParticipants(viewModel: SelectedTrip.Something.ViewModel) {
		guard let users = viewModel.users else {
			return
		}
		participantsArray = users
		participantsCollection.reloadData()
	}

	func makePhotosCollection() {
		photosCollection.delegate = self
		photosCollection.dataSource = self
		let nib = UINib(nibName: "PlaceCollectionViewCell", bundle: nil)
		photosCollection.register(nib, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
	}

	func makeParticipantsCollection() {
		participantsCollection.delegate = self
		participantsCollection.dataSource = self
		let nib = UINib(nibName: "ParticipantCollectionViewCell", bundle: nil)
		participantsCollection.register(nib, forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
	}

}

extension SelectedTripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == photosCollection {
			return photosArray.count
		}
		if collectionView == participantsCollection {
			return participantsArray.count
		}

		return 0
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == photosCollection {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	PlaceCollectionViewCell.identifier, for: indexPath)
					as? PlaceCollectionViewCell else {
				return UICollectionViewCell()
			}
			cell.imageOfLocation.image = photosArray[indexPath.row]
			cell.layer.borderWidth = 0
			cell.layer.shadowColor = UIColor.systemGray.cgColor
			cell.layer.shadowOffset = CGSize(width: 0.3, height: 0)
			cell.layer.shadowRadius = 3
			cell.layer.shadowOpacity = 0.5
			cell.layer.cornerRadius = 15
			cell.layer.masksToBounds = false
			return cell
		}

		if collectionView == participantsCollection {
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
		return UICollectionViewCell()
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView == photosCollection {
			return CGSize(width: 150, height: 150)
		}
		if collectionView == participantsCollection {
			return CGSize(width: 200, height: 100)
		}
		return CGSize(width: 150, height: 150)
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

		if collectionView == photosCollection {
			return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		}
		if collectionView == participantsCollection {
			return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 120)
		}
		return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}
