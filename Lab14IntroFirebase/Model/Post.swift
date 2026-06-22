//
//  Post.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import Foundation
import FirebaseFirestore


struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var authorEmail: String
    var category: String
    var likes: Int
    var isPublished: Bool
    var createdAt: Date
    
    init(title: String, content: String, authorEmail: String, likes: Int, category: String) {
        self.title = title
        self.content = content
        self.authorEmail = authorEmail
        self.category = category
        self.likes = likes
        self.isPublished = true
        self.createdAt = Date()
    }
}
