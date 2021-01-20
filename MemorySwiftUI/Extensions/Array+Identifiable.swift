//
//  Array+Identifiable.swift
//  MemorySwiftUI
//
//  Created by michelle gleed on 7/12/20.
//

import Foundation

extension Array where Element: Identifiable {
    
    func index(of item: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == item.id {
                return index
            }
        }
        return nil
    }
    
}
