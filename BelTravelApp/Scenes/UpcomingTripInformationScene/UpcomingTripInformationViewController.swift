//
//  UpcomingTripInformationViewController.swift
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

protocol UpcomingTripInformationDisplayLogic: class {
  func displayUsers(viewModel: UpcomingTripInformation.Something.ViewModel)
	func	displayUserViewController()
}

class UpcomingTripInformationViewController: UIViewController, UpcomingTripInformationDisplayLogic {
  var interactor: UpcomingTripInformationBusinessLogic?
  var router: (NSObjectProtocol & UpcomingTripInformationRoutingLogic & UpcomingTripInformationDataPassing)?

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
    let interactor = UpcomingTripInformationInteractor()
    let presenter = UpcomingTripInformationPresenter()
    let router = UpcomingTripInformationRouter()
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
		guard let tripInformation = tripInformation else {
			return
		}
		title = tripInformation.locationName
		locationImage.image = tripInformation.image
		tripStartPlace.text = tripInformation.description
		tripTime.text = tripInformation.time
		makeWhoWantToVisitThisPlaceCollection()
		loadParticipants()
	}

	func makeWhoWantToVisitThisPlaceCollection () {
		whoPacticipateCollection.delegate = self
		whoPacticipateCollection.dataSource = self
		let nib = UINib(nibName: "ParticipantCollectionViewCell", bundle: nil)
		whoPacticipateCollection.register(nib, forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
	}
  
  // MARK: Do something
	var tripInformation: NewTrip?
	var participantsArray = [FirebaseAuthManager.FullInformationAppUser]()
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var tripStartPlace: UILabel!
	@IBOutlet weak var tripTime: UILabel!
	@IBOutlet weak var whoPacticipateCollection: UICollectionView!
	@IBAction func chatButtonAction(_ sender: Any) {
		//interactor.setTrip(request: request)
		router?.routeToChatViewController()
	}

	@IBAction func participateButtonAction(_ sender: Any) {
			FirebaseDatabaseManager.shered.addParticipantInTrip(with: tripInformation!) { result in
				print(result)
			}
	}

	func loadParticipants() {
		let request = UpcomingTripInformation.Something.Request(trip: tripInformation!)
    interactor?.loadUsers(request: request)

  }
  
  func displayUsers(viewModel: UpcomingTripInformation.Something.ViewModel) {
	  self.participantsArray = viewModel.users
	  self.whoPacticipateCollection.reloadData()
  }

	func displayUserViewController() {
		router?.routeToUserViewController()
	}
}

extension UpcomingTripInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return participantsArray.count

	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

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
			return CGSize(width: 200, height: 100)
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
		if collectionView == whoPacticipateCollection {
			let request = UpcomingTripInformation.Something.Request(user: participantsArray[indexPath.row])
			interactor?.setUser(request: request)
		}
	}
}
