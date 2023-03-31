//
//  Categories.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 23.06.2022.
//

import Foundation

struct Categories: Decodable {

    let drinks: [CategoryName]

}

struct CategoryName: Decodable, Hashable {

    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }

    let name: String

}
