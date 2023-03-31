//
//  DrinkDetailViewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 10.08.2022.
//

import UIKit

struct DrinkDetailViewModel {

    let drink: Drink
    let items: [DetailsCellModel]
    var isFavorite: Bool

    init(drink: Drink, favoriteDrinks: [String]) {
        self.drink = drink

        var ingredientItems: [DetailsCellModel] = [
            .ingredientImage(
                DrinkDetailViewModel.getIngredientImageURLs(
                    ingredients: drink.ingredients.map { $0.name }
                )
            )
        ]

        ingredientItems.append(
            contentsOf: drink.ingredients.map {
                DetailsCellModel.ingredient(name: $0.name, measure: $0.measure ?? " - ")
            }
        )
        items = ingredientItems
        isFavorite = favoriteDrinks.contains(drink.id)
    }

}

// MARK: - Helpers

extension DrinkDetailViewModel {

    static func getIngredientImageURLs(ingredients: [String]) -> [String?] {
        ingredients.map {
            AppConfiguration.baseApiIngredientsImageString + ($0) + AppConfiguration.baseApiImageExtension
        }
    }

}

enum DetailsCellModel {
    case ingredientImage([String?])
    case ingredient(name: String, measure: String)
}
