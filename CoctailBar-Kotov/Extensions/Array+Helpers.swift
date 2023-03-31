//
//  Array+Helpers.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 06.09.2022.
//

import Foundation

extension Array where Element: Hashable {
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    
}
