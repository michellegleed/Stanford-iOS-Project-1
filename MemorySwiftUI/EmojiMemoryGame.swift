//
//  EmojiMemoryGame.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 5/12/20.
//

/// VIEW MODEL - presents the model to the views in a way that's easily consumable by the views. Shouldn't be doing logic in the views! The views just present whatever content they're given.

import SwiftUI


/// Lots of views need to access the view model. That's why ViewModel is a class!!

class EmojiMemoryGame: ObservableObject {
    
    
    static var themes = [
        Theme(name: "Halloween 🎃", colour: .orange, items: ["🎃", "👻", "🕸", "💀", "🕷", "🧛🏻‍♂️", "🧟‍♀️"], randomNumberOfPairs: true),
        Theme(name: "Christmas 🎄", colour: .green, items: ["🤶", "🎅", "🎄", "🎁", "🥂", "🦃"], randomNumberOfPairs: true),
        Theme(name: "Animals 🦁", colour: .yellow, items: ["🐶", "🦊", "🐷", "🦁", "🐼", "🐯", "🐹", "🐮", "🐸", "🐭"], randomNumberOfPairs: false)
    ]
    
    static var currentTheme: Theme?
    
    // only EmojiMemoryGame can modify the model, but all the views can still see the model
//    private(set) var model: MemoryGame<String>
    
//    private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 2) { _ in "😈" }
    
    /// ObservableObject only works for classes. ObservableObject protocol gives you a var called objectWillChange which of type ObservableObjectPublisher. So it publishes every time the ViewModel changes. We can call this publisher using objectWillChange.send(). See choose() func for a manual example...
    
    /// @Published means that whenever this var changes (which in this case is our model! So whenever our model changes...), the app will call objectWillChange.send() so we don't need to remember to put it everywhere ourselves :)
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
//        let emojis: Array<String> = ["🎃", "👻", "🕸", "💀", "🕷"]
        currentTheme = EmojiMemoryGame.chooseTheme(from: EmojiMemoryGame.themes)
        if let currentTheme = currentTheme {
            let numberOfPairs = currentTheme.randomNumberOfPairs ? Int.random(in: 2...currentTheme.items.count) : currentTheme.items.count
            return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
                return currentTheme.items[pairIndex]
            }
        }
        return MemoryGame<String>(numberOfPairsOfCards: 0) { pairIndex in
            return ""
        }
    }
    
    private static func chooseTheme(from themeOptions: [Theme]) -> Theme {
        let index = Int.random(in: 0..<themeOptions.count)
        return themeOptions[index]
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    // MARK: - Computed vars for the Views
    
    var title: String {
        return EmojiMemoryGame.currentTheme?.name ?? ""
    }
    
    var colour: Color {
        return EmojiMemoryGame.currentTheme?.colour ?? .gray
    }
    
    // MARK: - Controlled way for Views to access the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    // access the Card struct nested inside the MemoryGame struct like this: MemoryGame<String>.Card
    func choose(card: MemoryGame<String>.Card) {
///        objectWillChange.send()
        model.choose(card: card)
    }
}

struct Theme {
    var name: String
    var colour: Color
    var items: [String]
    var randomNumberOfPairs: Bool
}
