//
//  SliderViewController.swift
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

protocol SliderDisplayLogic: class {
	func updateyCollectionView(viewModel: [Slider.Something.ViewModel])
}

class SliderViewController: UIViewController, SliderDisplayLogic {
	var interactor: SliderBusinessLogic?
	var router: (NSObjectProtocol & SliderRoutingLogic & SliderDataPassing)?
	var sliderPages: [Slider.Something.ViewModel]?
	var authVC: AuthorizationViewController?
	var regVC: RegistrationViewController?
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
		let interactor = SliderInteractor()
		let presenter = SliderPresenter()
		let router = SliderRouter()
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
		doSomething()
		setUpPageControl()
	}

	// MARK: Do something

	@IBOutlet weak var slidersCollectionView: UICollectionView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	func setUpPageControl() {
		pageControl.numberOfPages = 2
		pageControl.currentPage = 0
	}

	func doSomething() {
		let request = Slider.Something.Request()
		interactor?.doSomething(request: request)
	}

	func updateyCollectionView(viewModel: [Slider.Something.ViewModel]) {
		sliderPages = viewModel
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		slidersCollectionView.collectionViewLayout = layout
		slidersCollectionView.delegate = self
		slidersCollectionView.dataSource = self

		slidersCollectionView.register(UINib(nibName: SliderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SliderCollectionViewCell.identifier)
		slidersCollectionView.showsHorizontalScrollIndicator = false
		slidersCollectionView.isPagingEnabled = true
		slidersCollectionView.backgroundColor = .clear
	}

	@objc func openAuthorizationVC() {
		router?.routeToAuthorization()
	}

	@objc func openRegistrationVC() {
		router?.routeToRegister()
	}
}

extension SliderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
		func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			self.sliderPages?.count ?? 0
		}

		func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as! SliderCollectionViewCell
			cell.config(model: (sliderPages?[indexPath.row])!)
			cell.registrationButtonOutlet.addTarget(self, action: #selector(openRegistrationVC), for: .touchUpInside)
			cell.authorizationButtonOutlet.addTarget(self, action: #selector(openAuthorizationVC), for: .touchUpInside)
			return cell
		}

		func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
			return self.view.frame.size
		}

		 func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let scrollPos = scrollView.contentOffset.x / view.frame.width
			pageControl.currentPage = Int(scrollPos)
		}
}
