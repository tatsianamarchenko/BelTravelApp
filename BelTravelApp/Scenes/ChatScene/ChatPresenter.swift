//
//  ChatPresenter.swift
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

protocol ChatPresentationLogic {
	func presentMesaages(response: Chat.Something.Response)
	func presentIsSended(response: Chat.Something.Response)
}

class ChatPresenter: ChatPresentationLogic {
	weak var viewController: ChatDisplayLogic?
	
	// MARK: Do something
	
	func presentMesaages(response: Chat.Something.Response) {
		let viewModel = Chat.Something.ViewModel(messages: response.messages!, message: nil)
		viewController?.displayMessages(viewModel: viewModel)
	}

	func presentIsSended(response: Chat.Something.Response) {
		let viewModel = Chat.Something.ViewModel(messages: response.messages, message: response.message)
		viewController?.displayNewMessages(viewModel: viewModel)
	}
}
