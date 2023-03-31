//
//  UserDefaultsInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 05.09.2022.
//

import Foundation

class UserDefaultsInteractor: StorageInteractorInterface {

    private let defaults = UserDefaults.standard

    func read(forKey: String) -> Any? {
        defaults.value(forKey: forKey)
    }

    func write(value: Any?, forKey: String) {
        defaults.set(value, forKey: forKey)
    }

    func delete(forKey: String) {
        defaults.set(nil ,forKey: forKey)
    }

}
