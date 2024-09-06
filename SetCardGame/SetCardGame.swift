//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import Foundation

struct SetCardGame {
    private var deck: [Card]
    private(set) var selectedCards: [Card] = []
    private(set) var cardsOnDisplay: [Card]
    private var isMatch = false
    
    mutating func drawThreeMoreCards() {
        cardsOnDisplay.append(contentsOf: deck.prefix(3))
        deck.removeFirst(3)
    }
    
    mutating func select(_ card: Card) {
        if(isMatch) {
            isMatch = false
            cardsOnDisplay.removeAll(where: { selectedCards.contains($0)})
            drawThreeMoreCards()
            selectedCards.removeAll()
        }
        
        if selectedCards.contains(card) && !isMatch {
            selectedCards.removeAll(where: { $0 == card })
            return
        }
        
        if cardsOnDisplay.count < 3 {
            selectedCards.append(card)
            return
        } else {
            isMatch = checkForSet(selectedCards[0], selectedCards[1], selectedCards[3])
            
        }
    }
    
    func checkForSet(_ cardOne: Card, _ cardTwo: Card, _ cardThree: Card) -> Bool {
        func allSameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
            return (a == b && b == c) || (a != b && a != c && b != c)
        }
        
        return allSameOrAllDifferent(cardOne.shape, cardTwo.shape, cardThree.shape) &&
               allSameOrAllDifferent(cardOne.color, cardTwo.color, cardThree.color) &&
               allSameOrAllDifferent(cardOne.shading, cardTwo.shading, cardThree.shading) &&
               allSameOrAllDifferent(cardOne.numberOfShapes, cardTwo.numberOfShapes, cardThree.numberOfShapes)
    }
    
    struct Card: Equatable {
        let shape: Shape
        let color: Color
        let shading: Shade
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
                            let card = Card(shape: shape, color: color, shading: shade, numberOfShapes: numberOfShapes)
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
