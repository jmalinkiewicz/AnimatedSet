//
//  CardView.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 08/09/2024.
//

import SwiftUI

struct CardView: View, Animatable {
    private var viewModel: SetCardGameViewModel
    private let card: SetCardGame.Card
    private let isSelected: Bool
    private var isFaceUp: Bool {
        rotation > 90
    }
    
    
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 1))
            if isFaceUp {
                CardContent(card)
                    .padding()
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.orange)
                    .padding()
            }
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
        .overlay(content: {
            isSelected ? RoundedRectangle(cornerRadius: 14).foregroundStyle(.yellow).opacity(0.15) : nil
        })
        .scaleEffect(isSelected ? 0.9 : 1)
        .background(matchEffect)
        .padding(2)
    }
    
    @ViewBuilder
    private var matchEffect: some View {
        isSelected && viewModel.selectedCards.count == 3 ? RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(viewModel.isMatch ? .green : .red): nil
    }
    
    @ViewBuilder
    private var selectionEffect: some View {
        isSelected ? RoundedRectangle(cornerRadius: 14).foregroundStyle(.yellow).opacity(0.15) : nil
    }
    
    init(_ card: SetCardGame.Card, viewModel: SetCardGameViewModel) {
        self.rotation = card.isFaceUp ? 180 : 0
        self.card = card
        self.viewModel = viewModel
        self.isSelected = viewModel.selectedCards.contains(card)
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
                Diamond()
                    .strokeBorder(lineWidth: 2)
                    .aspectRatio(1, contentMode: .fit)
                    .shapePainter(color: card.color, shade: .solid)
                Diamond()
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

#Preview {
    CardView(SetCardGame.Card(id: UUID(), shape: .diamond, color: .green, shade: .striped, numberOfShapes: .one), viewModel: SetCardGameViewModel())
        .padding()
        .background(.gray)
}
