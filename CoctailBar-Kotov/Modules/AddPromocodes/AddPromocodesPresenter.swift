//
//  AddPromocodesPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.09.2022.
//

import UIKit

final class AddPromocodesPresenter: NSObject {

    private let router: AddPromocodesRouter
    private let interactor: AddPromocodesInteractor

    weak var viewController: AddPromocodesViewController?

    init(_ router: AddPromocodesRouter, _ interactor: AddPromocodesInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension AddPromocodesPresenter: PromocodeTextFieldDelegate {

    func loadView() {
        let viewModel = AddPromocodeViewModel(promocode: interactor.promocode)
        viewController?.updateView(with: viewModel)
        validateTextFields()
    }

    func didBeginEditing() {
        viewController?.setPromocodeState(false)
    }

    func didEndEditing(textField: UITextField) {
        viewController?.setPromocodeState(textField.text?.count != 6)
    }

    func updatePromocode(_ promocode: String?) {
        guard let promocode = promocode else { return }
        interactor.promocode.title = promocode
        validateTextFields()
    }

    func createPromocode() {
        interactor.promocodesStorageService.changePromocode(interactor.promocode)
        router.dismiss()
    }

    func amountTextFieldChanged(_ text: String?) {
        guard let text = text else { return }
        interactor.promocode.discount = Int(text) ?? 0
        validateTextFields()
    }

    func startExpirationTextFieldChanged(_ text: String?) {
        interactor.promocode.startDate = text
        validateTextFields()
    }

    func endExpirationTextFieldChanged(_ text: String?) {
        interactor.promocode.endDate = text
        validateTextFields()
    }

    func validateTextFields() {
        viewController?.updateCreateButtonState(interactor.promocode.isValid)
    }

}
