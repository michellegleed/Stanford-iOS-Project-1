//
//  MemoryGame.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 5/12/20.
//

/// MODEL

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private (set) var cards: Array<Card>
    
    private (set) var score = 0
    
    private var indexOfFaceUpCard: Int? {
        get {
            //            var faceUpCardIndices = [Int]()
            //            for index in cards.indices {
            //                if cards[index].isFaceUp {
            //                    faceUpCardIndices.append(index)
            //                }
            //            }
            //            if faceUpCardIndices.count == 1 {
            //                return faceUpCardIndices.first
            //            } else {
            //                return nil
            //            }
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        set {
            for index in cards.indices {
                //                if index == newValue {
                //                    cards[index].isFaceUp = true
                //                }
                //                else {
                //                    cards[index].isFaceUp = false
                //                }
                /// this replaces commented code above :)
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    /// All funcs in a struct that modify the struct (ie. modify self) have to be marked as mutating! This is the way swift knows it will be changed and knows to make a new copy of the struct and store it in memory.
    mutating func choose(card: Card) {
        if let index = cards.index(of: card), !cards[index].isFaceUp, !cards[index].isMatched {
            
            if let faceUpCardIndex = indexOfFaceUpCard {
                if cards[index].content == cards[faceUpCardIndex].content {
                    cards[index].isMatched = true
                    cards[faceUpCardIndex].isMatched = true
                    score += 2
                } else {
                    if !cards[index].isFirstFlip { score -= 1 }
                    if !cards[faceUpCardIndex].isFirstFlip { score -= 1 }
                    cards[index].isFirstFlip = false
                    cards[faceUpCardIndex].isFirstFlip = false
                }
                cards[index].isFaceUp = true
            }
            else {
                indexOfFaceUpCard = index
            }
        }
        print("score: ", score)
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
        
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isFirstFlip = true
        
        var content: CardContent
        
        // MARK: - Bonus Time
        
        /// This could give bonus points if the user matches the card before
        /// a certain amount of time passes during which the card is face up
        
        
        // could be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // cumulative time this card has been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up
        // (and is still face up - this gets set to nil whenever card is flipped back down)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (ie. not including this current time if it is currently face up)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
