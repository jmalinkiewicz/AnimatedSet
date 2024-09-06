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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                ForEach(viewModel.cardsOnDisplay.indices, id: \.self) { index in
                    CardView(card: viewModel.cardsOnDisplay[index])
                    
                }
            })
        }
        .padding()
        Button("Draw 3 More Cards", action: {
            viewModel.drawThreeMoreCards()
        })
        .disabled(viewModel.deck.count < 3)
    }
}

struct CardView: View {
    let card: SetCardGame.Card
    
    var body: some View {
        Text("\(card.shape)")
    }
}

#Preview {
    SetCardGameView()
        .environment(SetCardGameViewModel())
}
