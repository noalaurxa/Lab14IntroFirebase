//
//  UserProfileView.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import SwiftUI
struct UserProfileView: View {
    @StateObject private var profileService = UserProfileService()
    @State private var displayName = ""
    @State private var showingNameInput = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("My Profile")
                .font(.title)
                .fontWeight(.bold)
            
            // Show user info or loading
            if let user = self.profileService.currentUser {
                VStack(spacing: 15) {
                    
                    // User circle with first letter
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(user.displayName.prefix(1).uppercased())
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text(user.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user.email)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Simple stats
                    HStack(spacing: 30) {
                        VStack {
                            Text("\(user.messageCount)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("Messages")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("Change Name") {
                        displayName = user.displayName
                        showingNameInput = true
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
            } else {
                // No profile yet
                VStack(spacing: 15) {
                    Text("No profile found")
                        .font(.headline)
                    
                    Text("Create your profile to get started!")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("Create Profile") {
                        showingNameInput = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            profileService.loadUser()
        }
        .alert("Enter Your Name", isPresented: $showingNameInput) {
            TextField("Display Name", text: $displayName)
            Button("Save") {
                if !displayName.isEmpty {
                    profileService.saveUser(displayName: displayName)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will be shown to other users")
        }
    }
}
#Preview {
    UserProfileView()
}
