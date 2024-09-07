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
    
    
    func cardContentFactory(_ card: SetCardGame.Card) -> some View {
        
        @ViewBuilder
        var shape: some View {
            switch card.shape {
            case .diamond:
                ZStack {
                    Rectangle()
                        .rotation(.degrees(45), anchor: .center)
                       .strokeBorder(lineWidth: 2)
                       .aspectRatio(1, contentMode: .fit)
                       .shapePainter(color: card.color, shade: .solid)
                    Rectangle()
                        .rotation(.degrees(45), anchor: .center)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(1)
                        .shapePainter(color: card.color, shade: card.shade)
                }
            case .squiggle:
                ZStack {
                    Rectangle()
                       .strokeBorder(lineWidth: 2)
                       .aspectRatio(3/1, contentMode: .fit)
                       .shapePainter(color: card.color, shade: .solid)
                    Rectangle()
                        .aspectRatio(3/1, contentMode: .fit)
                        .padding(1)
                        .shapePainter(color: card.color, shade: card.shade)
                }

            case .oval:
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                       .strokeBorder(lineWidth: 2)
                       .aspectRatio(3/1, contentMode: .fit)
                       .shapePainter(color: card.color, shade: .solid)
                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(3/1, contentMode: .fit)
                        .padding(1)
                        .shapePainter(color: card.color, shade: card.shade)
                }

            }
        }
    
        @ViewBuilder
        var content: some View {
            VStack(spacing: 20) {
                ForEach(0..<card.numberOfShapes.rawValue, id: \.self) { _ in
                    shape
                }
            }
        }
        
        return content
    }
}

struct ShapePainter: ViewModifier {
    let color: SetCardGame.Card.Color
    let shade: SetCardGame.Card.Shade
    
    var bgColor: Color {
        switch color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    var bgOpacity: Double {
        switch shade {
        case .solid:
            return 1
        case .striped:
            return 0.45
        case .open:
            return 0.05
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(bgColor.opacity(bgOpacity))
    }
}

extension View {
    func shapePainter(color: SetCardGame.Card.Color, shade: SetCardGame.Card.Shade) -> some View {
        modifier(ShapePainter(color: color, shade: shade))
    }
}
