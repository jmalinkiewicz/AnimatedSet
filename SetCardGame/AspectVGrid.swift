//
//  AspectVGrid.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 07/09/2024.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: max(gridItemSize, 70)), spacing: 0)], spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                .animation(.easeIn(duration: 0.2), value: items.count)
            }
        }
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        
        
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
        
    }
}
