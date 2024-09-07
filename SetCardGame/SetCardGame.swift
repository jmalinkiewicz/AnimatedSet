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
    
    mutating func drawThreeMoreCards() {
        if deck.count < 3 { return }
        
        cardsOnDisplay.append(contentsOf: deck.prefix(3))
        deck.removeFirst(3)
    }
    
    mutating func select(_ card: Card) {
        if (selectedCards.count == 3 && !isMatch) {
            selectedCards.removeAll()
        }
        
        if (isMatch) {
            isMatch = false
            let newCards = deck.prefix(3)
            deck.removeFirst(3)
            
            for i in 0..<3 {
                let indexToReplace = cardsOnDisplay.firstIndex(of: selectedCards[i])
                cardsOnDisplay[indexToReplace ?? 0] = newCards[i]
            }
            selectedCards.removeAll()
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
        self.cardsOnDisplay = Array(self.deck.prefix(12))
        self.deck.removeFirst(12)
    }
}
