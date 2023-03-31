//
//  DrinksInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 07.07.2022.
//

import Foundation

final class DrinksInteractor {

    let drinksService = DrinksNetworkService()
    let favoriteStorageService = FavoritesStorageService.shared

    var categories: [CategoryName] = []
    var categoryDrinks: [String: [Drink]] = [:]
    var selectedCategories: [String] = []
    var randomDrinks: Set<Drink> = []

}
