//
//  EditProfileFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

class EditProfileFabric {

    class func assembleScreen(router: EditProfileRouter, userName: String) -> EditProfileViewController {
        let interactor = EditProfileInteractor(userName)
        let presenter = EditProfilePresenter(router, interactor)
        let viewController = EditProfileViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
