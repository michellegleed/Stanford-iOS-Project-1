//
//  Pie.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 8/12/20.
//

import Foundation
import SwiftUI

/// Make our custom shape conform to the Shape protocol. Shape protocol returns a view.
/// All shapes also conform to the Animatable protocol (it's built-in to Shape) so we don't need to include it after the Shape protocol. Don't forget the animatableData property though if you're wanting to animate the shape!! It's required to conform to Animatable.
struct Pie: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    /// react is the rect of the space offered to this view.
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startPoint = CGPoint(
            x: center.x + radius * cos (CGFloat(startAngle.radians)),
            y: center.y + radius * sin (CGFloat(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: startPoint)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        p.addLine(to: center)
        
        return p
    }
    
    
}
