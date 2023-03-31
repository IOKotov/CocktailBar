//
//  PromocodeTextField.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 09.09.2022.
//

import UIKit

protocol PromocodeTextFieldDelegate: AnyObject {
    func didBeginEditing()
    func didEndEditing(textField: UITextField)
    func updatePromocode(_ promocode: String?)
}

final class PromocodeTextField: BaseTextField {

    weak var promocodeTextfieldDelegate: PromocodeTextFieldDelegate?

    override init() {
        super.init()

        keyboardType = .alphabet
        autocapitalizationType = .allCharacters
        placeholder = "JP5F1N"

        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UITextFieldDelegate

extension PromocodeTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }

        let currentText = text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let verified = updatedText ~= "^[A-Z0-9]{1,6}$"

        promocodeTextfieldDelegate?.updatePromocode(verified ? updatedText : nil)

        return verified
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        promocodeTextfieldDelegate?.didBeginEditing()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        promocodeTextfieldDelegate?.didEndEditing(textField: textField)
    }

}
