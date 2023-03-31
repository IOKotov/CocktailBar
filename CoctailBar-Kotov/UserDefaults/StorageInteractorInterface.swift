//
//  StorageInteractorInterface.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 05.09.2022.
//

import Foundation

protocol StorageInteractorInterface {
    func read(forKey: String) -> Any?
    func write(value: Any?, forKey: String)
    func delete(forKey: String)
}

extension StorageInteractorInterface {

    func read(forKey: Session.StorageKeys) -> Any? {
        read(forKey:forKey.rawValue)
    }

    func write(value: Any?, forKey: Session.StorageKeys) {
        write(value: value, forKey: forKey.rawValue)
    }

    func delete(forKey: Session.StorageKeys) {
        delete(forKey: forKey.rawValue)
    }
    
    

}
