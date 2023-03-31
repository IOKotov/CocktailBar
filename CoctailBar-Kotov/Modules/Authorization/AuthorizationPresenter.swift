//
//  AuthorizationPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 18.07.2022.
//

import Foundation
import UIKit

final class AuthorizationPresenter: NSObject {

    private let router: AuthorizationRouter
    private let interactor: AuthorizationInteractor
    
    private var sendedCode: Int = 0

    weak var viewController: AuthorizationViewController?

    init(_ router: AuthorizationRouter, _ interactor: AuthorizationInteractor) {
        self.router = router
        self.interactor = interactor
    }

    func generateNotification() {
        let randomCode = Int.random(in: 000001...999999)

        let content = UNMutableNotificationContent()
        content.title = "Your code for log in"
        content.body = "Do not give this code to anyone: \(randomCode)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                print("Error \(error?.localizedDescription ?? "")")
                return
            }
            self.sendedCode = randomCode
        }
    }

}

//MARK: - PhoneNumberTextFieldDelegate

extension AuthorizationPresenter: PhoneNumberTextFieldDelegate {

    func didBeginEditing() {
        validateSendTextFields()
    }

    func didEndEditing(textField: UITextField) {
        validateSendTextFields()
    }

    func updatePhoneNumber(_ number: String?) {
        guard let number = number else { return }
        interactor.parameters.phone = number
        validateSendTextFields()
    }

    func enterAuthorizationButton() {
        guard interactor.parameters.code == "\(sendedCode)" else {
            return }
        let userData = Data(interactor.parameters.phone.utf8)
        Session.shared.saveKey(userData)
        router.authorizationComplete()
    }

    func phoneNumberTextFieldChanged(_ text: String?) {
        guard let text = text else { return }
        interactor.parameters.phone = text
        validateEnterTextFields()
        validateSendTextFields()
    }

    func codeTextFieldChanged(_ text: String?) {
        guard let text = text else { return }
        interactor.parameters.code = text
        validateEnterTextFields()
    }

    func validateEnterTextFields() {
        viewController?.updateSignInButtonState(
            interactor.parameters.isValidEnter
        )
    }

    func validateSendTextFields() {
        viewController?.updateSendSmsButtonState(
            interactor.parameters.isValidSendCode
        )
    }

}
