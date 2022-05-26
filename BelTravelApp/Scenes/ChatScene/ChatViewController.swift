//
//  ChatViewController.swift
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
import MessageKit
import InputBarAccessoryView
import FirebaseAuth

protocol ChatDisplayLogic: class {
  func displayMessages(viewModel: Chat.Something.ViewModel)
	func displayNewMessages(viewModel: Chat.Something.ViewModel)
}

class ChatViewController: MessagesViewController, ChatDisplayLogic
{
  var interactor: ChatBusinessLogic?
  var router: (NSObjectProtocol & ChatRoutingLogic & ChatDataPassing)?

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
    let interactor = ChatInteractor()
    let presenter = ChatPresenter()
    let router = ChatRouter()
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

	let selfSender = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "-")
	var messages = [Message]()
	var tripInfo: NewTrip?

	override func viewDidLoad() {
		super.viewDidLoad()
		makeCollection()
		loadMessages()
	}

	func makeCollection() {
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messageInputBar.delegate = self
		showMessageTimestampOnSwipeLeft = true
	}
  
  // MARK: Do something

	func loadMessages() {
		let request = Chat.Something.Request(tripInfo: tripInfo!)
    interactor?.loadMessages(request: request)
  }
  
  func displayMessages(viewModel: Chat.Something.ViewModel) {
	  self.messages = viewModel.messages!
	  self.messages.sort {
		  $0.sentDate < $1.sentDate
	  }
	  self.messagesCollectionView.reloadDataAndKeepOffset()
  }

	func displayNewMessages(viewModel: Chat.Something.ViewModel) {
		DispatchQueue.main.async {
			self.messages.append(viewModel.message!)
			self.messages.sort {
				$0.sentDate < $1.sentDate
			}
			self.messagesCollectionView.reloadDataAndKeepOffset()
		}
	}
}

extension ChatViewController : MessagesDisplayDelegate, MessagesDataSource, MessagesLayoutDelegate {

	func currentSender() -> SenderType {
		selfSender
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		messages[indexPath.section]
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		messages.count
	}
}

extension ChatViewController: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let message = Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text(text))
		let request = Chat.Something.Request(tripInfo: tripInfo!, message: message, messageText: text)
		interactor?.sendMessage(request: request)
		inputBar.inputTextView.text = nil
	}
}
