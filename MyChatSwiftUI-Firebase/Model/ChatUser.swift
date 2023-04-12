//
//  ChatUser.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 12.04.2023.
//

import Foundation

struct ChatUser {
    let uid, email, profileImageUrl : String
    
    init(data: [String:Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
