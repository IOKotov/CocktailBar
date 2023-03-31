//
//  PromoCodesViewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 02.08.2022.
//

import UIKit

struct PromocodeCellModel {

    var id: UUID
    let title: String
    let discount: String
    var discountType: DiscountType = .discountRed
    var period: String? = "Period: -"

    init(promocode: Promocode) {
        id = promocode.id
        title = promocode.title ?? ""
        discount = "-\(promocode.discount ?? 0)%"
        discountType = getDiscountType(with: promocode.discount ?? 0)

        let startDate = getFormattedDate(dateString: promocode.startDate, format: "dd.MM.yy")
        let endDate = getFormattedDate(dateString: promocode.endDate, format: "dd.MM.yy")

        if let startDate = startDate, let endDate = endDate {
            period = "Period: \(startDate) - \(endDate)"
        } else if let startDate = startDate, endDate == nil {
            period = "Period: from \(startDate)"
        } else if let endDate = endDate, startDate == nil {
            period = "Period: to \(endDate)"
        }
    }

    private func getDiscountType(with percent: Int) -> DiscountType {
        DiscountType.getType(with: percent)
    }

    private func getFormattedDate(dateString: String?, format: String) -> String? {
        guard let dateString = dateString else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"

        let date = formatter.date(from: dateString) ?? Date()

        formatter.dateFormat = format
        return formatter.string(from: date)
    }

}
