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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    SetCardGameView()
        .environment(SetCardGameViewModel())
}
