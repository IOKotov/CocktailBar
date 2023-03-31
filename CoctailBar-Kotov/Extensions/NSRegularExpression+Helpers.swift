//
//  NSRegularExpression+Helpers.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 09.09.2022.
//

import Foundation

extension NSRegularExpression {
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
}
