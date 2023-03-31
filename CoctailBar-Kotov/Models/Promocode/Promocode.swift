//
//  Promocode.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 03.08.2022.
//

import Foundation

struct Promocode: Codable {

    var id = UUID()
    var title: String?
    var discount: Int?
    var startDate: String?
    var endDate: String?

    var isValid: Bool {
        guard let title = title, let discount = discount else { return false }
        return title.count == 6 && 1...99 ~= discount
    }

    var isNewPromocode: Bool { title == nil }

}
