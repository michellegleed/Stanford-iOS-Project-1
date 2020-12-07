//
//  Grid.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 7/12/20.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let grid = GridLayout(itemCount: items.count, in: geometry.size)

            /// ForEach only works on arrays containing types that are identifiable, so on line 10, we say grid accepts a type <Item> which is generic, where Item conforms to Identifiable. Now the Grid will only take an array of identifiable items as it's items property.
            ForEach(items) { item in

                if let index = items.index(of: item) {
                /// This is what we are returning so it has to be a View! So the type ItemView (which is what gets returned from this viewForItem function must conform to the view protocol. We specify this on line 10.
                viewForItem(item)
                    .frame(width: grid.itemSize.width, height: grid.itemSize.height)
                    .position(grid.location(ofItemAt: index))
                }
            }

        }
    }
}


