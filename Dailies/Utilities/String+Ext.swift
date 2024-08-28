//
//  String+Ext.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import Foundation

extension String {
    func trimmingTrailingSlash() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
