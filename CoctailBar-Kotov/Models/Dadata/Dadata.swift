//
//  Dadata.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 31.10.2022.
//

import Foundation

struct Suggestions: Decodable {

    let suggestions: [Suggestion]

}

struct Suggestion: Hashable, Decodable {

    let value: String

}
