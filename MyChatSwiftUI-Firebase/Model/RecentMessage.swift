//
//  RecentMessage.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 9.05.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable{

    @DocumentID var id: String?
    let text, email: String
    let fromId, toId : String
    let profileImageUrl: String
    let timestamp: Date
}

