//
//  AuthorizationParameters.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 19.07.2022.
//

import Foundation

struct AuthorizationParameters {
 
    var phone: String = ""
    var code: String = ""

    var isValidEnter: Bool {
        !phone.isEmpty && !code.isEmpty && code.count == 6
    }
    var isValidSendCode: Bool {
        !phone.isEmpty && phone.count == 17
    }

}
