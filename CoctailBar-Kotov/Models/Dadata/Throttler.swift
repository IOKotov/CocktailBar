//
//  Throttler.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 07.11.2022.
//

import Foundation

class Throttler {

    private var searchTask: DispatchWorkItem?
    
    let networkService = DadataNetworkService()

    deinit {
        print("Throttler object deiniantialized")
    }

    func throttle(query: String, block: @escaping (_ suggessions: [Suggestion]) -> Void) {
        searchTask?.cancel()

       let task = DispatchWorkItem { [weak self] in
           guard let self = self else { return }
           self.networkService.getSuggestions(query: query) { items in
               block(items?.suggestions ?? [])
           }
        }

        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: task)
    }

}
