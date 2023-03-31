//
//  DadataNetworkService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 28.10.2022.
//

import Foundation

final class DadataNetworkService {

    func getSuggestions(query: String, completion: @escaping (Suggestions?) -> Void) {
        let plugin: DadataApi = .getAdressSuggestions(query)
        NetworkRequest<Suggestions>.request(plugin: plugin) { response in
            completion(response)
        }
    }

}
