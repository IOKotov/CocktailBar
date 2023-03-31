//
//  DrinkDetailNetworkService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 13.07.2022.
//

import Foundation

protocol DrinkDetailNetworkServiceInterface {
    func getDrinkDetails(id: String, completion: @escaping (CategoryDrinks?) -> Void)
}

final class DrinkDetailNetworkService: DrinkDetailNetworkServiceInterface {

    func getDrinkDetails(id: String, completion: @escaping (CategoryDrinks?) -> Void) {
        let plugin: OnboardingApi = .getDrinkDetails(id)
        NetworkRequest<CategoryDrinks>.request(plugin: plugin) { response in
            completion(response)
        }
    }

}
