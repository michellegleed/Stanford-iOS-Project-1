//
//  Cardify.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 9/12/20.
//

import SwiftUI


//struct Cardify: ViewModifier {
struct Cardify: AnimatableModifier {
    
    /// AnimatableModifier protocal requires a property called animatableData.
    /// So we want to animate the rotation angle, and we could pass in animatableData to the .rotation3DEffect(Angle.degrees(...)) but it's not very good code cos it's difficult for someone else to understand what animatableData is. So we are using a getter and setter to make the rotation and animatableData always equal to each other, and now we can pass in rotation as the Angle.degrees() argument which makes more sense :)
    var animatableData: Double {
        get {
            return rotation
        }
        set {
            rotation = newValue
        }
    }
    
    var rotation: Double
    
    /// Here we are calculating isFaceUp based on the rotation of the card (soooo clever!) So if the rotation is less than 90 degs we want to show the front of the card, else if it's more (in this case 180 degs is card face down) then we show the back of the card. Without this the animation was showing the picture on the card straight away and flipping the card afterwards.
    var isFaceUp: Bool {
        rotation < 90
    }
    
//    var colour: Color
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
//        self.colour = colour
    }
    
//    func body(content: Content) -> some View {
//        ZStack {
//            if isFaceUp {
//                RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white)
//                RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.orange, lineWidth: edgeLineWidth)
//                content
//            } else {
//                RoundedRectangle(cornerRadius: cornerRadius).fill()
//            }
//        }
//        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
//    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0: 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
