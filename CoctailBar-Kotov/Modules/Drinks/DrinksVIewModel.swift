//
//  VIewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 21.07.2022.
//

import UIKit

struct DrinksViewModel {

    var sections: [DrinkSectionModel]
    var filterIcon: UIImage?

    init(categories: [CategoryName],
         categoryDrinks: [String: [Drink]],
         randomDrinks: [Drink],
         selectedCategories: [String] = [],
         favoriteDrinks: [String]) {

        let list = selectedCategories.isEmpty ? categories.map { $0.name } : selectedCategories

        sections = [DrinkSectionModel(
            title: "",
            items: randomDrinks.map {
                DrinkCellModel(
                    drink: $0,
                    isFavorite: favoriteDrinks.contains($0.id)
                )
            },
            kind: .random
        )]

        sections.append(
            contentsOf: list.map { category in
                DrinkSectionModel(
                    title: category,
                    items: categoryDrinks[category]?.map { drink in
                        DrinkCellModel(
                            drink: drink,
                            isFavorite: favoriteDrinks.contains(drink.id)
                        )
                    } ?? [],
                    kind: .drinks
                )
            }
        )

        filterIcon = selectedCategories.isEmpty ? UIImage(named: "filterIcon") : UIImage(named: "activeFilterIcon")?.withRenderingMode(.alwaysOriginal)
    }

}

struct DrinkSectionModel {

    enum Kind {
        case random
        case drinks
    }

    let title: String
    let items: [DrinkCellModel]
    let kind: Kind

}

struct DrinkCellModel {

    let drink: Drink
    let isFavorite: Bool

}
