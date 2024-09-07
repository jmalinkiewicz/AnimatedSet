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
                    let content = viewModel.cardContentFactory(card)
                    
                    CardView(card: card, content: content as! AnyView)
                }
            })
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
    let content: AnyView
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(.white)
                .shadow(radius: 2)
            content
                .padding()
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

#Preview {
    SetCardGameView()
        .environment(SetCardGameViewModel())
}
