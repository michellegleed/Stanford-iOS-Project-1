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
    
    var body: some View {
        
        VStack {
            HStack {
                Text(viewModel.title)
                Spacer()
                Text("Score: \(viewModel.score)")
                Spacer()
                Button("New Game") {
                    withAnimation(.easeInOut(duration: 2)) {
                        viewModel.newGame()
                    }
                }
            }
            .font(Font.system(size: titleFontSize, weight: .bold))
            .padding()
            
            Grid(items: viewModel.cards) { card in
                CardView(card: card).onTapGesture(perform: {
                    withAnimation(.linear(duration: 0.75)) {
                        viewModel.choose(card: card)
                    }
                })
                .padding(5)
            }
            .padding()
            /// You can use ternary opetators inside view modifiers like this...
            ///        .font(viewModel.cards.count <= 8 ? Font.largeTitle : Font.subheadline)
        }.foregroundColor(viewModel.colour)
    }
    
    // MARK: - Drawing Constants
    
    private let titleFontSize: CGFloat = 24
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    @State private var showPlusOne = false
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    private func setPlusOne() {
        showPlusOne = true
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.65, repeats: false) { timer in
            withAnimation {
                showPlusOne = false
            }
        }
    }
    
    var body: some View {
        return GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        /// Angle.degrees(0) starts at the middle right so x: maxX, y: midY instead of at 0,0 like you'd expect. So we need to subtract 90 degrees from each angle.
                        /// Because swiftUI Views have the coordinates 0,0 in their top left (not like Cartesian coordinates), everything gets drawn upside down! So we set clockwise as false on our shape, but to draw it the way we want, we have to switch clockwise to true because of the upside-down 🧟‍♀️🙃
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                                /// when pie appears, start the animation
                                .onAppear {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                        }
                    }
                    .padding(5)
                    .opacity(0.4)
                    
                    Text(card.content)
                        .font(Font.system(size: calculateFontSize(for: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                    
                    if card.isMatched {
                        ZStack {
                            if showPlusOne {
                                Text("+1")
                                    .font(Font.custom("MarkerFelt-Wide", size: 56))
                                    .bold()
                                    .foregroundColor(.green)
                                    .transition(AnyTransition.offset(x: 0, y: -100).animation(Animation.easeOut(duration: 5.0)).combined(with: .opacity))
                            }
                        }.onAppear{
                                setPlusOne()
                        }
                    }
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
            }
        }
    }
    
    // MARK: - Drawing Constants
    // logic for calculating the size of the emojis based on the side of the cards...
    private let fontScaleFactor: CGFloat = 0.7
    
    private func calculateFontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

extension AnyTransition {
    
    static var moveAndFade: AnyTransition {
        
        let removal = AnyTransition.move(edge: .top).combined(with: .opacity)
        
        return .asymmetric(insertion: .identity, removal: removal)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return ContentView(viewModel: game)
    }
}
