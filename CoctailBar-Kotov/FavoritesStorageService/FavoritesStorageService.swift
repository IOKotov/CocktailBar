//
//  FavoritesStorageService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.08.2022.
//

import Foundation

@objc protocol FavoritesSubscriber {
    func operationCompletedFor(_ id: String)
}

class FavoritesStorageService {

    static let shared = FavoritesStorageService()

    private var subscribers = NSHashTable<FavoritesSubscriber>.weakObjects()

    func subscribe(_ subscriber: FavoritesSubscriber) {
        subscribers.add(subscriber)
    }

    func unsubcribe(_ subscriber: FavoritesSubscriber) {
        subscribers.remove(subscriber)
    }

    func getFavoriteDrinks() -> [String] {
        Session.shared.getFavoriteDrinks()
    }

    func favoritesDrinksAction(_ id: String) {
        var drinks = getFavoriteDrinks()
        drinks.contains(id) ? removeDrinkFromFavorites(id, drinks: &drinks) : saveDrinkToFavorites(id, drinks: &drinks)
        
        Session.shared.saveDrinkToFavourites(drinks)

        notifySubscribersOperationCompleted(id)
    }

    private func saveDrinkToFavorites(_ id: String, drinks: inout [String]) {
        drinks.append(id)
    }

    private func removeDrinkFromFavorites(_ id: String, drinks: inout [String]) {
        drinks.removeAll(where: { $0 == id} )
    }

    private func notifySubscribersOperationCompleted(_ id: String) {
        for subscriber in subscribers.allObjects {
            subscriber.operationCompletedFor(id)
        }
    }
    
}
