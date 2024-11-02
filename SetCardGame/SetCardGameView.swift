//
//  SetCardGameView.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 06/09/2024.
//

import SwiftUI

struct SetCardGameView: View {
    @Environment(SetCardGameViewModel.self) private var viewModel
    @Namespace private var deckNamespace
    
    var body: some View {
        ZStack {
            cards
                .padding(.horizontal)
            VStack {
                Spacer()
                controls
                .padding(.horizontal, 20)
            }
        }
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cardsOnDisplay, aspectRatio: 2/3) { card in
            CardView(card, viewModel: viewModel)
                .padding(2)
                .onTapGesture {
                    viewModel.select(card)
                }
                .matchedGeometryEffect(id: card.id, in: deckNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
        }
    }
    
    var controls: some View {
        HStack(alignment: .top) {
            ZStack {
                ForEach(viewModel.discardedCards, content: { card in
                    CardView(card, viewModel: viewModel)
                })
            }
            .frame(width: 100 * 2/3, height: 100)
            Spacer()
                Button("New Game") {
                    viewModel.newGame()
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))
                .shadow(radius: 2)
                .alignmentGuide(.top) { _ in -50}
            Spacer()
            ZStack {
                ForEach(viewModel.deck.reversed(), content: { card in
                    CardView(card, viewModel: viewModel)
                        .matchedGeometryEffect(id: card.id, in: deckNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                })
            }
            .onTapGesture {
                var delay: TimeInterval = 0
                
                for _ in 0..<3 {
                    withAnimation(.easeInOut(duration: 1).delay(delay)) {
                        viewModel.drawCard()
                    }
                    
                    delay += 0.25
                }
            }
            .frame(width: 100 * 2/3, height: 100)
        }
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
