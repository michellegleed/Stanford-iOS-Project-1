//
//  MemorySwiftUIApp.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 5/12/20.
//

import SwiftUI

@main
struct MemorySwiftUIApp: App {
    
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
