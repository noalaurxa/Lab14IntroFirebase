//
//  PostQueryService.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
internal import Combine

class PostQueryService: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var queryDescription = ""
    
    private let db = Firestore.firestore()
    
    // MARK: - WHERE Queries
    
    // Get posts by specific category
    func getPostsByCategory(_ category: String) {
        isLoading = true
        queryDescription = "WHERE category == '\(category)'"
        
        db.collection("posts")
            .whereField("category", isEqualTo: category)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.handleQueryResult(snapshot: snapshot, error: error)
                }
            }
    }
        
    // Get popular posts (likes > 10)
    func getPopularPosts() {
        isLoading = true
        queryDescription = "WHERE likes > 10"
        
        db.collection("posts")
            .whereField("likes", isGreaterThan: 10)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.handleQueryResult(snapshot: snapshot, error: error)
                }
            }
    }
    
    // MARK: - ORDER BY Queries
    
    // Get posts ordered by creation date (newest first)
    func getPostsByNewest() {
        isLoading = true
        queryDescription = "ORDER BY createdAt DESC"
        
        db.collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.handleQueryResult(snapshot: snapshot, error: error)
                }
            }
    }
    
    
    // MARK: - LIMIT Queries
    
    // Get only the first 3 posts
    func getFirst3Posts() {
        isLoading = true
        queryDescription = "LIMIT 3"
        
        db.collection("posts")
            .limit(to: 3)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.handleQueryResult(snapshot: snapshot, error: error)
                }
            }
    }
        
    // MARK: - Helper Methods


    private func handleQueryResult(snapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("Query error: \(error.localizedDescription)")
            return
        }
        
        guard let documents = snapshot?.documents else {
            print("No documents found")
            posts = []
            return
        }
        
        posts = documents.compactMap { document in
            try? document.data(as: Post.self)
        }
        
        print("✅ Query completed: \(posts.count) posts found")
        print("📊 Query: \(queryDescription)")
    }
    
    // MARK: - Add Sample Data
    
    func addSamplePosts() {
        let samplePosts = [
            Post(title: "Getting Started with SwiftUI",
                 content: "SwiftUI is Apple's modern UI framework...",
                 authorEmail: Auth.auth().currentUser?.email ?? "test@tecsup.edu.pe",
                 likes:5,
                 category: "swift"),
            Post(title: "Getting Started with Kotlin",
                 content: "UIKit is Apple's older UI framework...",
                 authorEmail: "jfarfan@tecsup.edu.pe",
                 likes:15,
                 category: "kotlin"),
            Post(title: "iOS Development Tips",
                 content: "Tips for iOS developers...",
                 authorEmail: Auth.auth().currentUser?.email ?? "test@tecsup.edu.pe",
                 likes:10,
                 category: "swift"),
            Post(title: "Push Notification Kotlin",
                 content: "Amazing feature to send messages...",
                 authorEmail: "jfarfan@tecsup.edu.pe",
                 likes:20,
                 category: "kotlin"),
            Post(title: "Firebase Basics",
                 content: "Learn Firebase fundamentals...",
                 authorEmail: "smontoya@tecsup.edu.pe",
                 likes:1,
                 category: "google")
        ]
        
        for (index, post) in samplePosts.enumerated() {
            var postWithLikes = post
            postWithLikes.createdAt = Date().addingTimeInterval(-Double(index * 86400)) // Different days
            
            do {
                try db.collection("posts").addDocument(from: postWithLikes)
                print("✅ Added sample post: \(post.title)")
            } catch {
                print("❌ Error adding post: \(error)")
            }
        }
    }
}
