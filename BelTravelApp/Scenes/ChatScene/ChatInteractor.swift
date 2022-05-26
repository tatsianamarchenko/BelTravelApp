//
//  ChatInteractor.swift
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

protocol ChatBusinessLogic {
  func loadMessages(request: Chat.Something.Request)
	func sendMessage(request: Chat.Something.Request)
}

protocol ChatDataStore {
var otherUserId: String? { get set }
	var chatId: String? { get set }
	var newTrip: NewTrip? { get set }
}

class ChatInteractor: ChatBusinessLogic, ChatDataStore {
	var presenter: ChatPresentationLogic?
	var worker: ChatWorker?
	var otherUserId: String?
	var chatId: String?
	var newTrip: NewTrip?

	// MARK: Do something

	func loadMessages(request: Chat.Something.Request) {
		worker = ChatWorker()
		worker?.doSomeWork()

		FirebaseDatabaseManager.shered.getAllMesages(tripInformation: request.tripInfo) { [weak self] messages in
			let response = Chat.Something.Response(messages: messages, isSended: nil, message: nil)
			self?.presenter?.presentMesaages(response: response)
		}
	}

	func sendMessage(request: Chat.Something.Request) {

		FirebaseDatabaseManager.shered.sendMessage(tripInformation: request.tripInfo, message: request.message!, messageText: request.messageText!) { [weak self] result in
			let response = Chat.Something.Response(messages: nil, isSended: result, message: request.message)
			self?.presenter?.presentIsSended(response: response)
		}
	}

}
