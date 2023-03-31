//
//  Session.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 05.09.2022.
//

import Foundation

class Session {

    static let shared = Session()

    enum StorageKeys: String {
        case cartDrinks
        case favoriteDrinks
        case promocodes
        case isFirstLaunch
        case user
        case order
    }

    private let storageInteractor = UserDefaultsInteractor()
    private let keyChainInteractor = KeyChainInteractor()

    // MARK: - Cart

    func getCartDrinks() -> [String: Int] {
        guard let cartDrinks = storageInteractor.read(forKey: .cartDrinks) as? [String: Int] else { return [:] }
        return cartDrinks
    }

    func saveDrinkToCart(_ cartDrinks: [String: Int]) {
        storageInteractor.write(value: cartDrinks, forKey: .cartDrinks)
    }

    // MARK: - Favourites

    func getFavoriteDrinks() -> [String] {
        guard let favoriteDrinks = storageInteractor.read(forKey: .favoriteDrinks) as? [String] else { return [] }
        return favoriteDrinks
    }

    func saveDrinkToFavourites(_ favoriteDrinks: [String]) {
        storageInteractor.write(value: favoriteDrinks, forKey: .favoriteDrinks)
    }

    // MARK: - Order

    func getOrder() -> Data? {
        guard let order = storageInteractor.read(forKey: .order) as? Data else { return nil }
        return order
    }

    func saveOrder(_ order: Data?) {
        storageInteractor.write(value: order, forKey: .order)
    }

    // MARK: - Promocodes

    func getPromocodes() -> Data? {
        guard let promocodes = storageInteractor.read(forKey: .promocodes) as? Data else { return nil }
        return promocodes
    }

    func savePromocodes(_ promocodes: Data?) {
        storageInteractor.write(value: promocodes, forKey: .promocodes)
    }

    // MARK: - isFirstLaunch

    func isFirstLaunch() -> Bool {
        guard let firstTimeLaunch = storageInteractor.read(forKey: .isFirstLaunch) as? Bool else { return true }
        return firstTimeLaunch
    }

    func writeFirstLaunch() {
        storageInteractor.write(value: false, forKey: .isFirstLaunch)
    }
    
    // MARK: - KeyChain

    func saveKey(_ userData: Data?) {
        keyChainInteractor.write(value: userData, forKey: .user)
    }
    
    func getDatakey() -> Data? {
        guard let key = keyChainInteractor.read(forKey: .user) as? Data else { return nil }
        return key
    }
    
    func deleteKey() {
        keyChainInteractor.delete(forKey: .user)
    }
    
    func isUserAutorized() -> Bool {
        getDatakey() != nil
    }

}
