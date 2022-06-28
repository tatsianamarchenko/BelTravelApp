//
//  MessageManager.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 28.06.22.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseDatabase

class MessageManager {

	static let shered = MessageManager()
	private let database = Firestore.firestore()

	func getAllMesages(tripInformation: NewTrip, complition : @escaping ([Message]) -> Void) {
		guard let document = tripInformation.document else {
			return
		}
		database.collection("\(tripInformation.region)Trips").document(document).collection(Constants.share.messagesCollection).getDocuments { (querySnapshot, _) in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}
			var messageRecived = [Message]()
			_ = documents.map { queryDocumentSnapshot in
				let	data = queryDocumentSnapshot.data()
				let messageText = data["message"] as? String ?? ""
				let sender = data["sender"] as? String ?? ""
				let stamp = data["data"] as? Timestamp
				let date = stamp?.dateValue() ?? Date()

				let message = Message(sender: Sender(senderId: sender, displayName: "-"),
									  messageId: queryDocumentSnapshot.documentID,
									  sentDate: date, kind: .text(messageText))
				messageRecived.append(message)
			}
			complition(messageRecived)
		}
	}

	func sendMessage(tripInformation: NewTrip,
					 message: Message,
					 messageText: String,
					 complition : @escaping (Bool) -> Void) {
		guard let document = tripInformation.document else {
			return
		}
		let path = database.collection("\(tripInformation.region)Trips").document(document)
		path.collection(Constants.share.messagesCollection).addDocument(data: [
			"data": Date(),
			"sender": message.sender.senderId,
			"message": messageText ]) { error in
				if error == nil {
					complition(true)
				} else {
					complition(false)
				}
			}
	}
}
