//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Abhishek on 08/02/26.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
        }
    }
}

/*
 App Development Plan:
 🟩 Game Intro screen
 - Gameplay screen
 ☑️ Game logic (questions, scores, etc.
 - Celebration
 ☑️ Audio
 ☑️ Animations
 - In-app purchases
 - Store
 ✅ Instructions screen
 🟩 Books
 - Persist score
 */
