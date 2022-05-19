//
//  SelectedPlaceViewController.swift
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

protocol SelectedPlaceDisplayLogic: class
{
  func displayResultOfAdding(viewModel: SelectedPlace.Something.ViewModel)
}

class SelectedPlaceViewController: UIViewController, SelectedPlaceDisplayLogic
{
  var interactor: SelectedPlaceBusinessLogic?
  var router: (NSObjectProtocol & SelectedPlaceRoutingLogic & SelectedPlaceDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = SelectedPlaceInteractor()
    let presenter = SelectedPlacePresenter()
    let router = SelectedPlaceRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
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
	  makeWhoWantToVisitThisPlaceCollection()
	  makePhotosOfOtherUsersCollection()
	  titleName.title = location?.name
	  locationImage.image = location?.image
	  desctiptionLable.text = location?.description
	  addTLocationToDataStore()
  }
  
  // MARK: Do something
	var location: Location?
	var region: String?
	
	@IBOutlet weak var titleName: UINavigationItem!
	@IBOutlet weak var whoWantToVisitThisPlaceCollection: UICollectionView!
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var photosOfOtherUsersCollection: UICollectionView!
	@IBOutlet weak var desctiptionLable: UILabel!
	@IBOutlet weak var noPhotoLable: UILabel!
	@IBOutlet weak var noParticipantsLable: UILabel!

	@IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
	@IBAction func addToFavoriteButton(_ sender: Any) {
		addToFavorite()
	}
	@IBAction func createTripAction(_ sender: Any) {
		router?.routeToCreatingViewController()
	}

	func addTLocationToDataStore() {
		let request = SelectedPlace.Something.Request(location: location!, region: region!)
		interactor?.addToDataStore(request: request)
	}

	var peopleWhoWansToParticipate = [FirebaseAuthManager.FullInformationAppUser]()
	var photosOfOtherUsers = [UIImage]()

	func makeWhoWantToVisitThisPlaceCollection () {
		whoWantToVisitThisPlaceCollection.delegate = self
		whoWantToVisitThisPlaceCollection.dataSource = self
		let nib = UINib(nibName: "ParticipantCollectionViewCell", bundle: nil)
		whoWantToVisitThisPlaceCollection.register(nib, forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
	}

	func makePhotosOfOtherUsersCollection () {
		photosOfOtherUsersCollection.delegate = self
		photosOfOtherUsersCollection.dataSource = self
		let nib = UINib(nibName: "PlaceCollectionViewCell", bundle: nil)
		photosOfOtherUsersCollection.register(nib, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
	}

	func addToFavorite() {
		let request = SelectedPlace.Something.Request(location: location!, region: region!)
		interactor?.addToFavorite(request: request)
	}
  
  func displayResultOfAdding(viewModel: SelectedPlace.Something.ViewModel) {
	  if viewModel.result == "Added" {
		print("added")
	  } else {
		  print(viewModel.result)
	  }
  }
}


extension SelectedPlaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == whoWantToVisitThisPlaceCollection {
			return peopleWhoWansToParticipate.count
		}
		if collectionView == photosOfOtherUsersCollection {
			return photosOfOtherUsers.count
		}
		return 0
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == whoWantToVisitThisPlaceCollection {

			if peopleWhoWansToParticipate.isEmpty {
				noParticipantsLable.isHidden = false
			}

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	ParticipantCollectionViewCell.identifier, for: indexPath)
					as? ParticipantCollectionViewCell else {
				return UICollectionViewCell()
			}
			cell.config(model: peopleWhoWansToParticipate[indexPath.row])
			cell.layer.borderWidth = 0
			cell.layer.shadowColor = UIColor.systemGray.cgColor
			cell.layer.shadowOffset = CGSize(width: 0.3, height: 0)
			cell.layer.shadowRadius = 3
			cell.layer.shadowOpacity = 0.5
			cell.layer.cornerRadius = 15
			cell.layer.masksToBounds = false
			return cell
		}

		if collectionView == photosOfOtherUsersCollection {
			if photosOfOtherUsers.isEmpty {
				noPhotoLable.isHidden = false
			}

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																	PlaceCollectionViewCell.identifier, for: indexPath)
					as? PlaceCollectionViewCell else {
				return UICollectionViewCell()
			}
					cell.imageOfLocation.image = photosOfOtherUsers[indexPath.row]
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
		if collectionView == whoWantToVisitThisPlaceCollection {
			return CGSize(width: 100, height: 100)
		}

		if collectionView == photosOfOtherUsersCollection {
			return CGSize(width: 150, height: 150)
		}

		return CGSize(width: 100, height: 100)
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
		if collectionView == whoWantToVisitThisPlaceCollection {
		}

		if collectionView == photosOfOtherUsersCollection {

		}
	}
}
