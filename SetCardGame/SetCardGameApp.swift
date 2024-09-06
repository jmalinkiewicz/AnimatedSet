//
//  SetCardGameApp.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import SwiftUI

@main
struct SetCardGameApp: App {
    @State private var game = SetCardGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
