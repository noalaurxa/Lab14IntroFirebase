//
//  UserProfileService.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
internal import Combine

class UserProfileService: ObservableObject {
    
    @Published var currentUser: UserProfile?
    private let db = Firestore.firestore()
    
    // Save user profile to Firestore
    func saveUser(displayName: String) {
        guard let firebaseUser = Auth.auth().currentUser,
              let email = firebaseUser.email else { return }
        
        let user = UserProfile(email: email, displayName: displayName)
        
        do {
            try db.collection("users").document(firebaseUser.uid).setData(from: user)
            self.currentUser = user
            print("User saved successfully!")
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    // Load user profile from Firestore
    func loadUser() {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        db.collection("users").document(firebaseUser.uid).getDocument { document, error in
            if let error = error {
                print("Error loading user: \(error)")
                return
            }
            
            if let document = document, document.exists {
                do {
                    self.currentUser = try document.data(as: UserProfile.self)
                    print("User loaded successfully!")
                } catch {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    
    // Update message count
    func addMessage() {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        db.collection("users").document(firebaseUser.uid).updateData([
            "messageCount": FieldValue.increment(Int64(1))
        ])
        
        // Update local count
        currentUser?.messageCount += 1
    }
}

