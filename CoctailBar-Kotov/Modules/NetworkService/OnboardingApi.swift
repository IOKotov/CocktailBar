//
//  OnboardingApi.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 24.06.2022.
//

import Foundation

enum OnboardingApi {
    case getCategories
    case getDrinksCategory(String)
    case getDrinkDetails(String)
    case getRandomDrinks
}

extension OnboardingApi: NetworkPlugin {

    private enum Parameters: String {
        case list
        case filter
        case category = "c"
        case id = "i"
    }

    var baseURL: URL {
        guard let url = URL(string: AppConfiguration.baseApiString) else {
            fatalError("incorrect base url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getCategories:
            return "/list.php"
        case .getDrinksCategory:
            return "/filter.php"
        case.getDrinkDetails:
            return "/lookup.php"
        case.getRandomDrinks:
            return "/random.php"
        }
    }

    var method: String { "GET" }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getCategories:
            return [
                URLQueryItem(
                    name: Parameters.category.rawValue,
                    value: Parameters.list.rawValue
                )
            ]
        case let .getDrinksCategory(category):
            return [
                URLQueryItem(
                    name: Parameters.category.rawValue,
                    value: category
                )
            ]
        case let .getDrinkDetails(id):
            return [
                URLQueryItem(
                    name: Parameters.id.rawValue,
                    value: id
                )
            ]
        case .getRandomDrinks:
            return []
        }
    }

}
