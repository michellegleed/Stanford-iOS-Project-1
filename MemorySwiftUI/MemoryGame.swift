//
//  MemoryGame.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 5/12/20.
//

/// MODEL

import Foundation

struct MemoryGame<CardContent> {
    
    var cards: Array<Card>
    
    /// All funcs in a struct that modify the struct (ie. modify self) have to be marked as mutating! This is the way swift knows it will be changed and knows to make a new copy of the struct and store it in memory.
    mutating func choose(card: Card) {
        print(card.content)
        if let index = cards.index(of: card) {
            cards[index].isFaceUp = !cards[index].isFaceUp
        }
    }
    
    /// We moved this func into an Array extension (see Array+Identifiable.swift file) because was using exact same code here AND in Grid.swift
//    func index(of chosenCard: Card) -> Int? {
//        for index in 0..<cards.count {
//            if cards[index].id == chosenCard.id {
//                return index
//            }
//        }
//        return nil
//    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = true
        var isMatched = false
        var content: CardContent
    }
}
