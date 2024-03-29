//
//  SaveTripViewController.swift
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

protocol SaveTripDisplayLogic: AnyObject {
	func displayProfile(viewModel: SaveTrip.Something.ViewModel)
}

class SaveTripViewController: UIViewController, SaveTripDisplayLogic {
	var interactor: SaveTripBusinessLogic?
	var router: (NSObjectProtocol & SaveTripRoutingLogic & SaveTripDataPassing)?
	
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
		let interactor = SaveTripInteractor()
		let presenter = SaveTripPresenter()
		let router = SaveTripRouter()
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
		setLabels()
		makePhotosCollection()
		makeParticipantsCollection()
		title = ""
	}
	
	// MARK: Do something
	
	var photosArray = [UIImage]()
	var participantsArray = [FullInformationAppUser]()
	
	@IBOutlet weak var noPhotosLable: UILabel!
	@IBOutlet weak var photosCollection: UICollectionView!
	@IBOutlet weak var noParticipantsLable: UILabel!
	@IBOutlet weak var participantsCollection: UICollectionView!
	
	@IBOutlet weak var addPhotosOutlet: UIButton!
	@IBAction func addPhotosAction(_ sender: Any) {
		presentPhoto()
	}
	
	@IBOutlet weak var saveOutlet: UIButton!
	@IBAction func saveTripAction(_ sender: Any) {
		let request = SaveTrip.Something.Request(photos: photosArray)
		interactor?.saveImages(request: request)
	}
	
	func makePhotosCollection () {
		photosCollection.delegate = self
		photosCollection.dataSource = self
		let nib = UINib(nibName: "PlaceCollectionViewCell", bundle: nil)
		photosCollection.register(nib, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
	}
	
	func makeParticipantsCollection () {
		participantsCollection.delegate = self
		participantsCollection.dataSource = self
		let nib = UINib(nibName: "ParticipantCollectionViewCell", bundle: nil)
		participantsCollection.register(nib, forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
	}
	
	func setLabels() {
		noPhotosLable.text = NSLocalizedString("noPhotoLable", comment: "")
		noParticipantsLable.text = NSLocalizedString("noParticipateLable", comment: "")
		addPhotosOutlet.setTitle(NSLocalizedString("addPhotoButton", comment: ""), for: .normal)
		saveOutlet.setTitle(NSLocalizedString("saveButton", comment: ""), for: .normal)
	}
	
	func displayProfile(viewModel: SaveTrip.Something.ViewModel) {
		router?.routeToProfile(source: self)
	}
}

extension SaveTripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
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
			if !photosArray.isEmpty {
				noPhotosLable.isHidden = true
			}
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	PlaceCollectionViewCell.identifier, for: indexPath)
					as? PlaceCollectionViewCell else {
				return UICollectionViewCell()
			}
			
			cell.config(image: photosArray[indexPath.row])
			return cell
		}
		
		if collectionView == participantsCollection {
			if !participantsArray.isEmpty {
				noParticipantsLable.isHidden = true
			}
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	ParticipantCollectionViewCell.identifier, for: indexPath)
					as? ParticipantCollectionViewCell else {
				return UICollectionViewCell()
			}
			
			cell.config(model: participantsArray[indexPath.row])
			return cell
		}
		
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return Constants.share.profileImageSize
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
		if collectionView == photosCollection {
		}
		
		if collectionView == participantsCollection {
			
		}
	}
}

extension SaveTripViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
		private func photoWithCamera() {
			let viewController = UIImagePickerController()
			viewController.sourceType = .camera
			viewController.delegate = self
			viewController.allowsEditing = true
			self.present(viewController, animated: true)
		}
	
		private func photoFromLibrary() {
			let viewController = UIImagePickerController()
			viewController.sourceType = .photoLibrary
			viewController.delegate = self
			viewController.allowsEditing = true
			self.present(viewController, animated: true)
		}
	
		func presentPhoto() {
			let choose = UIAlertController(title: "Profile Photo",
										   message: "How would you like to select a photo?",
										   preferredStyle: .actionSheet)
			let library = UIAlertAction(title: "photo library", style: .default) { [weak self] _ in
				self?.photoFromLibrary()
			}
			let camera = UIAlertAction(title: "take photo", style: .default) { [weak self] _ in
				self?.photoWithCamera()
			}
			let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
			choose.addAction(library)
			choose.addAction(camera)
			choose.addAction(cancel)
			self.present(choose, animated: true)
		}
	
	func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any] ) {
		picker.dismiss(animated: true, completion: nil)
		guard  let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
			return
		}
		self.photosArray.append(selectedImage)
		photosCollection.reloadData()
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
}
