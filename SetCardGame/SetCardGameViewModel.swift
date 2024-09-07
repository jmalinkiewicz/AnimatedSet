//
//  SetCardGameViewModel.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import SwiftUI

@Observable class SetCardGameViewModel {
    private var model = SetCardGame()
    
    var cardsOnDisplay: [SetCardGame.Card] {
        return model.cardsOnDisplay
    }
    var selectedCards: [SetCardGame.Card] {
        return model.selectedCards
    }
    var isMatch: Bool {
        return model.isMatch
    }
    
    var deck: [SetCardGame.Card] {
        return model.deck
    }
    
    func select(_ card: SetCardGame.Card) {
        model.select(card)
    }
    
    func drawThreeMoreCards() {
        model.drawThreeMoreCards()
    }
    
}
