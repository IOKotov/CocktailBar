//
//  KeyChainInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.10.2022.
//

import Foundation
import Security

class KeyChainInteractor: StorageInteractorInterface {

    func read(forKey: String) -> Any? {
        let query = [kSecClass as String:kSecClassGenericPassword as String,
                     kSecAttrAccount as String: forKey,
                     kSecReturnData as String: kCFBooleanTrue ?? false,
                     kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    func write(value: Any?, forKey: String) {
        let query = [kSecClass as String:kSecClassGenericPassword as String,
                     kSecAttrAccount as String: forKey,
                     kSecValueData as String: value as Any
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func delete(forKey: String) {
        let query = [kSecClass as String:kSecClassGenericPassword as String,
                     kSecAttrAccount as String: forKey,
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
    }

}
