//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import Foundation

struct SetCardGame {
    private(set) var deck: [Card]
    private(set) var selectedCards: [Card] = []
    private(set) var cardsOnDisplay: [Card]
    private(set) var isMatch = false
    private(set) var discardedCards: [Card] = []
    
    mutating func drawCard() {
        if deck.count < 1 { return }
        
        if (isMatch) {
            respondToMatch(replace: true)
            return;
        }
        
        var cardsToAdd = Array(deck.prefix(1))
        for index in 0..<cardsToAdd.count {
            cardsToAdd[index].isFaceUp = true
        }
    
        cardsOnDisplay.append(contentsOf: cardsToAdd)

        deck.removeFirst(1)
    }
    
    mutating func respondToMatch(replace: Bool = false) {
        isMatch = false
        
            for i in 0..<3 {
                let matchingCardIndex = cardsOnDisplay.firstIndex(of: selectedCards[i])
                
                if deck.count >= 3 {
                    var newCard = deck.removeFirst()
                    newCard.isFaceUp = true
                    
                    if replace {
                        discardedCards.append(selectedCards[i])
                        
                        cardsOnDisplay[matchingCardIndex ?? 0] = newCard
                    }
                    else {
                        discardedCards.append(selectedCards[i])
                        cardsOnDisplay.remove(at: matchingCardIndex ?? 0)
                    }
                } else {
                    discardedCards.append(selectedCards[i])
                    cardsOnDisplay.remove(at: matchingCardIndex ?? 0)
                }
            }
            selectedCards.removeAll()
    }
    
    mutating func select(_ card: Card) {
        if (selectedCards.count == 3 && !isMatch) {
            selectedCards.removeAll()
        }
        
        if (isMatch) {
            respondToMatch()
        }
        
        if selectedCards.count < 3 && !selectedCards.contains(card) {
            selectedCards.append(card)
            
            if selectedCards.count == 3 {
                isMatch = checkForSet(selectedCards[0], selectedCards[1], selectedCards[2])
            }
            
            return
        }
        if selectedCards.count < 3 && selectedCards.contains(card) {
            selectedCards.removeAll(where: { $0 == card })
            return
        }
        
    }
    
    mutating func newGame() {
        self = SetCardGame()
    }
    
    func checkForSet(_ cardOne: Card, _ cardTwo: Card, _ cardThree: Card) -> Bool {
        func allSameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
            return (a == b && b == c) || (a != b && a != c && b != c)
        }
        
        return allSameOrAllDifferent(cardOne.shape, cardTwo.shape, cardThree.shape) &&
               allSameOrAllDifferent(cardOne.color, cardTwo.color, cardThree.color) &&
               allSameOrAllDifferent(cardOne.shade, cardTwo.shade, cardThree.shade) &&
               allSameOrAllDifferent(cardOne.numberOfShapes, cardTwo.numberOfShapes, cardThree.numberOfShapes)
    }
    
    struct Card: Equatable, Identifiable {
        var id: UUID
        
        let shape: Shape
        let color: Color
        let shade: Shade
        let numberOfShapes: NumberOfShapes
        var isFaceUp = false
        
        enum Shape: CaseIterable {
            case diamond, squiggle, oval
        }
        
        enum Color: CaseIterable {
            case red, green, purple
            
        }
        
        enum Shade: CaseIterable {
            case solid, striped, open
        }
        
        enum NumberOfShapes: Int, CaseIterable {
            case one = 1, two, three
        }
    }

    
    init() {
        func makeDeckOfCards() -> [Card] {
            var deck = [Card]()
            
            for shape in Card.Shape.allCases {
                for color in Card.Color.allCases {
                    for shade in Card.Shade.allCases {
                        for numberOfShapes in Card.NumberOfShapes.allCases {
                            let card = Card(id: UUID(), shape: shape, color: color, shade: shade, numberOfShapes: numberOfShapes)
                            deck.append(card)
                        }
                    }
                }
            }
            return deck.shuffled()
        }
        
        
        self.deck = makeDeckOfCards()
        var initialCards = Array(self.deck.prefix(12))
        for index in 0..<initialCards.count {
            initialCards[index].isFaceUp = true
        }
        self.cardsOnDisplay = initialCards
        self.deck.removeFirst(12)
    }
}
