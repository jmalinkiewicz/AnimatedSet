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
        AspectVGrid(viewModel.cardsOnDisplay, aspectRatio: 2/3) { card in
            CardView(card, viewModel: viewModel)
                .padding(2)
                .onTapGesture {
                    viewModel.select(card)
                }
        }
        .padding()
        HStack {
            Button("Three More Cards") {
                viewModel.drawThreeMoreCards()
            }
            .disabled(viewModel.deck.count < 3)
            Spacer()
            Button("New Game") {
                viewModel.newGame()
            }
        }
        .padding(.horizontal, 40)
    }
}

struct Diamond: Shape, InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate the center of the rectangle
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Define the points for the diamond (a 45-degree rotated square)
        let top = CGPoint(x: center.x, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: center.y)
        let bottom = CGPoint(x: center.x, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: center.y)
        
        // Move to the top point
        path.move(to: top)
        
        // Draw lines to form the diamond
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.addLine(to: top)
        
        // Close the path to complete the shape
        path.closeSubpath()
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
            var diamond = self
            diamond.insetAmount += amount
            return diamond
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
