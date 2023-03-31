//
//  FavoritesInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

protocol FavoritesInteractorInterface {
    var drinkDetailService: DrinkDetailNetworkService { get }
    var favoritesStorageService: FavoritesStorageService { get }
    func getFavoritesWith(currentDrinks: [Drink], completion: @escaping ([Drink]) -> Void)
}

final class FavoritesInteractor: FavoritesInteractorInterface {

    let drinkDetailService = DrinkDetailNetworkService()
    let favoritesStorageService = FavoritesStorageService.shared

    func getFavoritesWith(currentDrinks: [Drink], completion: @escaping ([Drink]) -> Void) {
        let group = DispatchGroup()

        var drinks: [Drink] = currentDrinks
        let currentDrinkIds = currentDrinks.map { $0.id }
        let allDrinksIds = favoritesStorageService.getFavoriteDrinks()
        let differenceArray = currentDrinkIds.difference(from: allDrinksIds)

        differenceArray.forEach { id in
            group.enter()
            drinkDetailService.getDrinkDetails(id: id) { drink in
                guard let drink = drink?.drinks.first(where: { $0.id == id }) else {
                    group.leave()
                    return
                }

                drinks.append(drink)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(drinks)
        }
    }

}
