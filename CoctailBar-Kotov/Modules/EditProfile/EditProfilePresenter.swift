//
//  EditProfilePresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

final class EditProfilePresenter {

    private let router: EditProfileRouter
    private let interactor: EditProfileInteractor

    weak var viewController: EditProfileViewController?

    init(_ router: EditProfileRouter, _ interactor: EditProfileInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension EditProfilePresenter {
    
    func viewDidLoad() {
        let userName = interactor.parameters.userName
        viewController?.updateUserNameTextField(text: userName)
    }

    func enterChangeButton() {
        router.applyNewUserName(interactor.parameters.userName)
    }

    func nicknameTextFieldChanged(_ text: String?) {
        guard let text = text else { return }
        interactor.parameters.userName = text
        validateTextFields()
    }

    func validateTextFields() {
        viewController?.updateChangeNicknameButtonState(
            interactor.parameters.isValid
        )
    }

}
