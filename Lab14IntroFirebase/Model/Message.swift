//
//  Message.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import Foundation
struct Message: Codable, Identifiable {
    let id: String
    let text: String
    let userEmail: String
    let timestamp: Date
}
