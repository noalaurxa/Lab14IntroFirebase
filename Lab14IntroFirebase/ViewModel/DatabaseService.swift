//
//  DatabaseService.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 15/06/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
internal import Combine
import SwiftUI

class DatabaseService: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var messages: [Message] = []
    
    @StateObject private var profileService = UserProfileService()
    
    func startListening() {
        db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.messages = documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                }
            }
    }
    
    func addMessage(text: String) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let message = Message(
            id: UUID().uuidString,
            text: text,
            userEmail: user.email ?? "Unknown",
            timestamp: Date()
        )
        
        do {
            print("message \(message.userEmail)")
            try db.collection("messages").document(message.id).setData(from: message)
            
            profileService.addMessage()
            
        } catch {
            print("Error adding message: \(error)")
        }
    }
}
