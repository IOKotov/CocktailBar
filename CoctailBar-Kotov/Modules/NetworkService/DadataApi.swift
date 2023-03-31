//
//  DadataApi.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 28.10.2022.
//

import Foundation

enum DadataApi {
    case getAdressSuggestions(String)
}

extension DadataApi: NetworkPlugin {

    var baseURL: URL {
        guard let url = URL(string: AppConfiguration.dadataSuggestionsApi) else {
            fatalError("incorrect base url")
        }
        return url
    }

    var path: String { "" }

    var method: String { "GET" }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getAdressSuggestions(let string):
            return [URLQueryItem(name: "query", value: string)]
        }
    }

    var headers: [String: String] {
        ["Authorization": "Token f8e36e4d09c5801f71b86027e80260bbf7da3d6c",
         "Content-Type": "application/json",
         "Accept": "application/json"
        ]
    }

}
