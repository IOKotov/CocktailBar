//
//  String+Helpers.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 09.09.2022.
//

import Foundation

extension String {
    
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
}
