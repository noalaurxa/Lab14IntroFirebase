//
//  Lab14IntroFirebaseApp.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 15/06/26.
//

import SwiftUI
import FirebaseCore

@main
struct Lab14IntroFirebaseApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
