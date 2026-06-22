//
//  UserProfile.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import Foundation
struct UserProfile: Codable {
    
    let email: String
    var displayName: String
    var messageCount: Int
    
    init(email: String, displayName: String) {
        self.email = email
        self.displayName = displayName
        self.messageCount = 0
    }
}
