//
//  MessangeManager.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 4.05.22.
//

import Foundation
import MessageKit
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

struct Sender: SenderType {
	var senderId: String

	var displayName: String

}

struct Message: MessageType {
	var sender: SenderType

	var messageId: String

	var sentDate: Date

	var kind: MessageKind

}
