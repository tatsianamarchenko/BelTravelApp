//
//  MainViewController.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 10.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol MainDisplayLogic: class {
  func displaySomething(viewModel: Main.Something.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic {
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

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
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
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
	  makeCollections()
    doSomething()
  }

  let regions = [Region(image: Image(withImage: UIImage(named: "Minsk")!), name: "Minsk"),
				 Region(image: Image(withImage: UIImage(named: "Brest")!), name: "Brest"),
				 Region(image: Image(withImage: UIImage(named: "Vitebsk")!), name: "Vitebsk"),
				 Region(image: Image(withImage: UIImage(named: "Gomel")!), name: "Gomel"),
				 Region(image: Image(withImage: UIImage(named: "Grodno")!), name: "Grodno"),
				 Region(image: Image(withImage: UIImage(named: "Mogilev")!), name: "Mogilev")
  ]

	@IBOutlet weak var regionsCollection: UICollectionView!
	@IBOutlet weak var mostPopularPlacesCollection: UICollectionView!
	@IBOutlet weak var nextTripsCollection: UICollectionView!
	@IBOutlet weak var mapView: MKMapView!

	@IBAction func allLocationButtonAction(_ sender: Any) {
		router?.routeToAllLocationsViewController()
	}


	func makeCollections () {
		regionsCollection.delegate = self
		regionsCollection.dataSource = self
		let nib = UINib(nibName: "RegionCollectionViewCell", bundle: nil)
		regionsCollection.register(nib, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
	}
var regionName = "MinskRegion"
	func doSomething() {
    let request = Main.Something.Request(region: regionName)
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Main.Something.ViewModel) {
    //nameTextField.text = viewModel.name
  }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == regionsCollection {
			return regions.count
		}
		return 0
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
																RegionCollectionViewCell.identifier, for: indexPath)
				as? RegionCollectionViewCell else {
					return UICollectionViewCell()
				}
		cell.config(model: regions[indexPath.row])
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
	}
}
