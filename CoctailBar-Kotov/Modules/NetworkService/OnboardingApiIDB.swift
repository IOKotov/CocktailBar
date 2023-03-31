//
//  OnboardingApiIDB.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 22.09.2022.
//

import Foundation

enum OnboardingApiIDB {
    case getOnboarding
}

extension OnboardingApiIDB: NetworkPlugin {

    var baseURL: URL {
        guard let url = URL(string: AppConfiguration.baseApiOnboarding) else {
            fatalError("incorrect base url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getOnboarding:
            return AppConfiguration.baseApiOnboardingExtension
        }
    }

    var method: String { "GET" }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getOnboarding:
            return []
        }
    }

}
