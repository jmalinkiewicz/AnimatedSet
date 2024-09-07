//
//  SetCardGameView.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import SwiftUI

struct SetCardGameView: View {
    @Environment(SetCardGameViewModel.self) private var viewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], content: {
                ForEach(viewModel.cardsOnDisplay.indices, id: \.self) { index in
                    let card  = viewModel.cardsOnDisplay[index]
                    let isSelected = viewModel.selectedCards.contains(card)
                    
                    CardView(card)
                        .onTapGesture {
                            viewModel.select(card)
                        }
                        .overlay(content: {
                            isSelected ? RoundedRectangle(cornerRadius: 14).foregroundStyle(.yellow).opacity(0.15) : nil
                        })
                        .scaleEffect(isSelected ? 0.9 : 1)
                        .background(isSelected && viewModel.selectedCards.count == 3 ? RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(viewModel.isMatch ? .green : .red): nil)
                        .animation(.easeIn(duration: 0.1), value: isSelected)
                }
            })
            .animation(.easeIn(duration: 0.2), value: viewModel.cardsOnDisplay.count)
            .padding()
        }
        Button("Draw 3 More Cards", action: {
            viewModel.drawThreeMoreCards()
        })
        .disabled(viewModel.deck.count < 3)
    }
}

struct CardView: View {
    let card: SetCardGame.Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(.white)
                .shadow(radius: 2)
            CardContent(card)
                .padding()
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
    
    init(_ card: SetCardGame.Card) {
        self.card = card
    }
}

struct CardContent: View {
    let card: SetCardGame.Card
    
    var base: AnyView {
        switch card.shape {
        case .oval:
            return AnyView(ZStack {
                RoundedRectangle(cornerRadius: 10)
                   .strokeBorder(lineWidth: 2)
                   .aspectRatio(3/1, contentMode: .fit)
                   .shapePainter(color: card.color, shade: .solid)
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(3/1, contentMode: .fit)
                    .padding(1)
                    .shapePainter(color: card.color, shade: card.shade)
            })
        case .diamond:
            return AnyView(ZStack {
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
            })
        case .squiggle:
            return AnyView(ZStack {
                Rectangle()
                   .strokeBorder(lineWidth: 2)
                   .aspectRatio(3/1, contentMode: .fit)
                   .shapePainter(color: card.color, shade: .solid)
                Rectangle()
                    .aspectRatio(3/1, contentMode: .fit)
                    .padding(1)
                    .shapePainter(color: card.color, shade: card.shade)
            })
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<card.numberOfShapes.rawValue, id: \.self) { _ in
                base
            }
        }
    }
    
    init(_ card: SetCardGame.Card) {
        self.card = card
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

#Preview {
    SetCardGameView()
        .environment(SetCardGameViewModel())
}
