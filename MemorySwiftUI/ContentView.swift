//
//  ContentView.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 5/12/20.
//

/// VIEW

import SwiftUI

struct ContentView: View {
    
    /// This @ObservedObject property wrapper allows the ContentView to listen for any time objectWillChange.send() is called by the variable it's in front of, which in this case is our viewModel.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {

        Grid(items: viewModel.cards) { card in
                    CardView(card: card).onTapGesture(perform: {
                        viewModel.choose(card: card)
                    })
                    .padding(5)
            }

        .foregroundColor(.orange)
        .padding()
        /// You can use ternary opetators inside view modifiers like this...
///        .font(viewModel.cards.count <= 8 ? Font.largeTitle : Font.subheadline)
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.orange, lineWidth: edgeLineWidth)
                    Text(card.content)
                }
                else {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
//            .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
            .font(Font.system(size: calculateFontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
    func calculateFontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
