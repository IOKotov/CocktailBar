//
//  CartViewModel].swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit

struct CartViewModel {

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var totalPrice: String?

    var sections: [CartSectionModel] = []

    init(drinks: [Drink], promocode: Promocode?, drinksCount: [String: Int]) {
        guard !drinks.isEmpty else { return }
        sections = drinks.map {
            CartSectionModel(
                sectionType: .drink,
                items: [
                    .drink(
                        .init(
                            id: $0.id,
                            name: $0.name,
                            categoryName: $0.category,
                            imageUrlString: $0.imageURL,
                            count: drinksCount[$0.id] ?? 1,
                            price: 100
                        )
                    )
                ]
            )
        }

        let discount = promocode?.discount ?? .zero
        var formattedDiscount: String = ""
        if discount != .zero {
            formattedDiscount = "-\(discount)%"
        }
        sections.append(
            .init(
                sectionType: .promocode,
                items: [.promocode(.init(promocode: promocode?.title ?? ""))]
            )
        )

        let priceSum = drinks.reduce(0) { $0 + 100 * Double(drinksCount[$1.id] ?? 1) }
        let totalPrice = numberFormatter.string(from: priceSum - (priceSum * Double(discount)) / 100 as NSNumber) ?? ""
        self.totalPrice = totalPrice
        sections.append(
            .init(
                sectionType: .price,
                items: [
                    .price(
                        .init(
                            title: "Order price",
                            price: numberFormatter.string(from: priceSum as NSNumber) ?? ""
                        )
                    ),
                    .price(
                        .init(
                            title: "Discount",
                            price: discount != .zero ? formattedDiscount : "-"
                        )
                    ),
                    .price(
                        .init(
                            title: "Total price",
                            price: totalPrice
                        )
                    )
                ]
            )
        )
    }

}

struct CartSectionModel {

    enum SectionType {
        case drink
        case promocode
        case price
    }

    let sectionType: SectionType
    let items: [CartCellModel]

}

enum CartCellModel {
    case drink(CartDrinkCellModel)
    case promocode(CartPromocodeCellModel)
    case price(CartPriceCellModel)
}
