//
//  OnboardingNetworkService.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 24.06.2022.
//

import Foundation

protocol DrinksNetworkServiceInterface {
    func getCategories(completion: @escaping (Categories?) -> Void)
    func getCategoryDrinks(category: String,
                           completion: @escaping (CategoryDrinks?) -> Void)
    func getRandomDrinks(completion: @escaping (CategoryDrinks?) -> Void)
}

final class DrinksNetworkService: DrinksNetworkServiceInterface {

    func getCategories(completion: @escaping (Categories?) -> Void) {
        let plugin: OnboardingApi = .getCategories
        NetworkRequest<Categories>.request(plugin: plugin) { response in
            completion(response)
        }
    }

    func getCategoryDrinks(category: String,
                           completion: @escaping (CategoryDrinks?) -> Void) {
        let plugin: OnboardingApi = .getDrinksCategory(category)
        NetworkRequest<CategoryDrinks>.request(plugin: plugin) { response in
            completion(response)
        }
    }

    func getRandomDrinks(completion: @escaping (CategoryDrinks?) -> Void) {
        let plugin: OnboardingApi = .getRandomDrinks
        NetworkRequest<CategoryDrinks>.request(plugin: plugin) { response in
            completion(response)
        }
    }

}
