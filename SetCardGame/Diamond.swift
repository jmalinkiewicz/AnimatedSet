//
//  Diamond.swift
//  SetCardGame
//
//  Created by Jakub Malinkiewicz on 17/09/2024.
//

import SwiftUI

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
