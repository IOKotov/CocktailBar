//
//  CartStorageService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 01.09.2022.
//

import Foundation

@objc protocol CartSubscriber {
    func operationCompleted(_ id: String)
}

class CartStorageService {

    static let shared = CartStorageService()

    private var subscribers = NSHashTable<CartSubscriber>.weakObjects()

    func subscribe(_ subscriber: CartSubscriber) {
        subscribers.add(subscriber)
    }

    func unsubcribe(_ subscriber: CartSubscriber) {
        subscribers.remove(subscriber)
    }

    func getCartDrinks() -> [String: Int] {
        Session.shared.getCartDrinks()
    }

    func saveDrinkToCart(_ id: String, count: Int? = nil) {
        var drinks = getCartDrinks()
        drinks[id] = count != nil ? count : (drinks[id] ?? 0) + 1
        Session.shared.saveDrinkToCart(drinks)

        notifySubscribersOperationCompleted(id)
    }

    func removeDrinkFromCart(_ id: String) {
        var drinks = getCartDrinks()
        drinks.removeValue(forKey: id)
        Session.shared.saveDrinkToCart(drinks)
    }

    private func notifySubscribersOperationCompleted(_ id: String) {
        for subscriber in subscribers.allObjects {
            subscriber.operationCompleted(id)
        }
    }

}
