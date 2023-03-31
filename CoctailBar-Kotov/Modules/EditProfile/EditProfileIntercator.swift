//
//  EditProfileIntercator.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

final class EditProfileInteractor {

    var parameters = EditProfileParameters()

    init(_ userName: String) {
        parameters.userName = userName
    }

}
