//
//  EditProfileParameters.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 02.08.2022.
//

import Foundation

struct EditProfileParameters {
 
    var userName: String = ""

    var isValid: Bool {
        !userName.isEmpty && userName.count >= 3
    }

}
