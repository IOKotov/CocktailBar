//
//  CartInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit

protocol CartInteractorInterface {
    var cartStorageService: CartStorageService { get }
    var promocodeStorageService: PromocodesStorageService { get }
    var isRequesting: Bool { get }
    func getCartWith(currentDrinks: [Drink], completion: @escaping ([Drink]) -> Void)
}

final class CartInteractor: CartInteractorInterface {

    private let drinkDetailService = DrinkDetailNetworkService()

    let cartStorageService = CartStorageService.shared
    let promocodeStorageService = PromocodesStorageService.shared

    var isRequesting = false

    func getCartWith(currentDrinks: [Drink], completion: @escaping ([Drink]) -> Void) {
        guard !isRequesting else { return }
        isRequesting = true

        let group = DispatchGroup()
        var drinks: [Drink] = currentDrinks

        let currentDrinkIds = currentDrinks.map { $0.id }
        let allDrinksIds = Array(cartStorageService.getCartDrinks().keys)
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
            self.isRequesting = false
        }
    }

}
