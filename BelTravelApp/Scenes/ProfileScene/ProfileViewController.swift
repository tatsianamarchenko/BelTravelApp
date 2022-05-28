//
//  ProfileViewController.swift
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
import FirebaseAuth

protocol ProfileDisplayLogic: class {
	func displayUserInformation(viewModel: Profile.Something.ViewModel)
	func displayNewPhotoOfUser(viewModel: Profile.Something.ViewModel)
	func displayFinishTrip()
}

class ProfileViewController: UIViewController, ProfileDisplayLogic {
  var interactor: ProfileBusinessLogic?
  var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?

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
    let interactor = ProfileInteractor()
    let presenter = ProfilePresenter()
    let router = ProfileRouter()
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
		loadUserInformation()
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
		photoOfUser.isUserInteractionEnabled = true
		photoOfUser.addGestureRecognizer(tapGesture!)
		makeUpcomingTripsCollection()
		makeFinishedTripsCollection()
	}
	@objc func tapped() {
		presentPhoto()
	}
  
  // MARK: Do something
var upcomingTripsArray = [NewTrip]()
	var finishedTripsArray = [NewTrip]()
	var photoOfOtherUsers = [UIImage]()

	var tapGesture: UITapGestureRecognizer?
	@IBOutlet weak var nameLable: UILabel!
	@IBOutlet weak var photoOfUser: UIImageView!
	@IBOutlet weak var defaultLocationLable: UILabel!
	@IBOutlet weak var numberOfTripsOfUserLable: UILabel!
	@IBOutlet weak var finishedTripsCollection: UICollectionView!
	@IBOutlet weak var noFinishedTripsLable: UILabel!
	@IBOutlet weak var upcomingTripsCollection: UICollectionView!
	@IBOutlet weak var noUpcomingTripsLable: UILabel!
	
	@IBOutlet weak var locationLable: UILabel!
	@IBOutlet weak var tripsLable: UILabel!

	@IBAction func exitButton(_ sender: Any) {
		FirebaseAuthManager.shered.signOut {
			self.router?.routeToSliderViewController()
		}
	}

  func loadUserInformation() {
    let request = Profile.Something.Request()
    interactor?.loadInformation(request: request)
  }
  
	func displayUserInformation(viewModel: Profile.Something.ViewModel) {
		self.nameLable.text = "\(viewModel.name!) \(viewModel.lastName!)"
		self.defaultLocationLable.text = viewModel.defaultLocation
		self.numberOfTripsOfUserLable.text = viewModel.numberOfTripsOfUser
		guard let image = viewModel.newImage else {return}
		photoOfUser.image = image
		upcomingTripsArray = viewModel.upcomingTrips!
		finishedTripsArray = viewModel.finishedTrips!
		upcomingTripsCollection.reloadData()
		finishedTripsCollection.reloadData()
	}

	func displayNewPhotoOfUser(viewModel: Profile.Something.ViewModel) {
		guard let image = viewModel.newImage else {return}
		photoOfUser.image = image
	}

	func makeUpcomingTripsCollection () {
		upcomingTripsCollection.delegate = self
		upcomingTripsCollection.dataSource = self
		let nib = UINib(nibName: "UpcomingTripCollectionViewCell", bundle: nil)
		upcomingTripsCollection.register(nib, forCellWithReuseIdentifier: UpcomingTripCollectionViewCell.identifier)
	}
	func makeFinishedTripsCollection () {
		finishedTripsCollection.delegate = self
		finishedTripsCollection.dataSource = self
		let nib = UINib(nibName: "UpcomingTripCollectionViewCell", bundle: nil)
		finishedTripsCollection.register(nib, forCellWithReuseIdentifier: UpcomingTripCollectionViewCell.identifier)
	}

	func displayFinishTrip() {
		router?.routeToSelectedFinishedTripViewController()
	}
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == upcomingTripsCollection {
			return upcomingTripsArray.count
		}

		if collectionView == finishedTripsCollection {
			return finishedTripsArray.count
		}

		return 0
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


		if collectionView == upcomingTripsCollection {
			if !upcomingTripsArray.isEmpty {
				noUpcomingTripsLable.isHidden = true
			}

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	UpcomingTripCollectionViewCell.identifier, for: indexPath)
					as? UpcomingTripCollectionViewCell else {
				return UICollectionViewCell()
			}

			cell.config(model: upcomingTripsArray[indexPath.row])
			cell.layer.borderWidth = 0
			cell.layer.shadowColor = UIColor.systemGray.cgColor
			cell.layer.shadowOffset = CGSize(width: 0.3, height: 0)
			cell.layer.shadowRadius = 3
			cell.layer.shadowOpacity = 0.5
			cell.layer.cornerRadius = 15
			cell.layer.masksToBounds = false
			return cell
		}

		if collectionView == finishedTripsCollection {
			if !finishedTripsArray.isEmpty {
				noFinishedTripsLable.isHidden = true
			}

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	UpcomingTripCollectionViewCell.identifier, for: indexPath)
					as? UpcomingTripCollectionViewCell else {
				return UICollectionViewCell()
			}

			cell.config(model: finishedTripsArray[indexPath.row])
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
		if collectionView == upcomingTripsCollection {
			if upcomingTripsArray[indexPath.row].creator == Auth.auth().currentUser?.uid {
				print("mine")
			} else {
				"SelectedTripViewController"
			}
		}
		if collectionView == finishedTripsCollection {
			let request = Profile.Something.Request(image: nil, name: nil, finishedTrip: finishedTripsArray[indexPath.row])
			interactor?.setFinishTrip(request: request)
		}
	}
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func photoWithCamera(){
		let vc = UIImagePickerController()
		vc.sourceType = .camera
		vc.delegate = self
		vc.allowsEditing = true
		present(vc, animated: true)
	}
	func photoFromLibrary(){
		let vc = UIImagePickerController()
		vc.sourceType = .photoLibrary
		vc.delegate = self
		vc.allowsEditing = true
		present(vc, animated: true)
	}

	func presentPhoto(){
		let choose = UIAlertController(title: "Profile Photo", message: "How would you like to select a photo?", preferredStyle: .actionSheet)
		let library = UIAlertAction(title: "photo library", style: .default, handler: {[weak self] _ in self?.photoFromLibrary() } )
		let camera = UIAlertAction(title: "take photo", style: .default, handler: {[weak self] _ in self?.photoWithCamera()} )
		let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
		choose.addAction(library)
		choose.addAction(camera)
		choose.addAction(cancel)
		present(choose, animated: true)
	}

	func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any] ) {
		picker.dismiss(animated: true, completion: nil)
		guard  let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
			return
		}
		let request = Profile.Something.Request(image: selectedImage, name: "\(nameLable.text!)")
		interactor?.saveImageInDatabase(request: request)
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
}
