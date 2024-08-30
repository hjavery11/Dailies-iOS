//
//  Array+Ext.swift
//  Gamedles
//
//  Created by Harrison Javery on 8/30/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
