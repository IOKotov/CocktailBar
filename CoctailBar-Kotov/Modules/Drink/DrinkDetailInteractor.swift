//
//  DrinkDetailInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 13.07.2022.
//

import Foundation

final class DrinkDetailInteractor {

    let drinkDetailService = DrinkDetailNetworkService()
    
    let favoriteStorageService = FavoritesStorageService.shared
    let cartStorageService = CartStorageService.shared

    let id: String

    var drinkDetails: Drink?

    init(id: String) {
        self.id = id
    }

}
