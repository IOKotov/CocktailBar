//
//  File.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 21.07.2022.
//

import Foundation

protocol ClassIdentifiable {
    static var reuseId: String { get }
}

extension ClassIdentifiable {

    static var reuseId: String {
        return String(describing: self)
    }

}
