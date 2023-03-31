//
//  NetworkRequest.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 22.06.2022.
//

import Foundation

protocol NetworkPlugin {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension NetworkPlugin {

    var headers: [String: String] { [:] }

}

struct NetworkRequest<T: Decodable> {

    static func request(plugin: NetworkPlugin,
                        completion: @escaping (_ response: T?) -> Void) {
        var url = plugin.baseURL.appendingPathComponent(plugin.path)

        if !plugin.queryItems.isEmpty {
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: true
            )
            components?.queryItems = plugin.queryItems
            url = components?.url ?? url
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = plugin.method

        plugin.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if plugin.method == "POST" {
            if let encodedData = try? JSONSerialization.data(
                withJSONObject: plugin.queryItems,
                options: .prettyPrinted
            ) {
                urlRequest.httpBody = encodedData
            }
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }
 
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                completion(decodedData)
            } else {
                completion(nil)
            }
        }.resume()
    }

}
