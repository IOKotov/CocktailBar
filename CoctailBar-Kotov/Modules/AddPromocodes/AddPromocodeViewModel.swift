//
//  AddPromocodeViewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 14.09.2022.
//

import Foundation

struct AddPromocodeViewModel {

    let title: String
    let buttonTitle: String

    let promocode: String?
    var amount: String? = nil
    let startDate: String?
    let endDate: String?

    init(promocode: Promocode) {
        title = promocode.isNewPromocode ? "Add promocode" : "Edit promocode"
        buttonTitle = promocode.isNewPromocode ? "Create" : "Edit"
        self.promocode = promocode.title
        if let discount = promocode.discount {
            amount = "\(discount)"
        }
        startDate = promocode.startDate
        endDate = promocode.endDate
    }

}
