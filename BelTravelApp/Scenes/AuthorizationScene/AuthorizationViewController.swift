//
//  AuthorizationViewController.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 2.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AuthorizationDisplayLogic: class {
  func displayAuthorized(viewModel: Authorization.Something.ViewModel)
}

class AuthorizationViewController: UIViewController, AuthorizationDisplayLogic {
	var interactor: AuthorizationBusinessLogic?
	var router: (NSObjectProtocol & AuthorizationRoutingLogic & AuthorizationDataPassing)?
	let checkField = CheckField.shared
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
		let interactor = AuthorizationInteractor()
		let presenter = AuthorizationPresenter()
		let router = AuthorizationRouter()
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
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
		mainView.addGestureRecognizer(tapGesture!)
	}

	@objc func tapped() {
		self.view.endEditing(true)
	}

	// MARK: Do something

	var tapGesture: UITapGestureRecognizer?
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	@IBOutlet weak var emailView: UIView!
	@IBOutlet weak var passwordView: UIView!

	func displayAuthorized(viewModel: Authorization.Something.ViewModel) {
		router?.routeToMessengerTabBarViewController()
	}

	@IBAction func closeButtonAction(_ sender: Any) {
		self.dismiss(animated: true)
	}

	@IBAction func authorizationButtonAction(_ sender: UIButton) {
		if checkField.validField(emailView, emailTextField),
		   checkField.validField(passwordView, passwordTextField) {
			
			let request = Authorization.Something.Request(email: emailTextField.text ?? "", passward: passwordTextField.text ?? "")
			interactor?.doSomething(request: request)
		}
	}
}
