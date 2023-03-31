//
//  PhoneNumberTextField.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 04.10.2022.
//

import UIKit

protocol PhoneNumberTextFieldDelegate: AnyObject {
    func didBeginEditing()
    func didEndEditing(textField: UITextField)
    func updatePhoneNumber(_ number: String?)
}

final class PhoneNumberTextField: BaseTextField {
    
    weak var phoneNumberTextFieldDelegate: PhoneNumberTextFieldDelegate?
    
    override init() {
        super.init()
        
        keyboardType = .numberPad
        placeholder = "Phone number"
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UITextFieldDelegate

extension PhoneNumberTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (text ?? "") + string
        
        text = formatPhoneNumber(phoneNubmer: currentText, shouldRemoveLastDigit: range.length == 1)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneNumberTextFieldDelegate?.didBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneNumberTextFieldDelegate?.didEndEditing(textField: textField)
    }
    
    //MARK: - Helpers
    
    func formatPhoneNumber(phoneNubmer: String, shouldRemoveLastDigit: Bool) -> String {
        let maxPhoneNumberCount = 11
        guard let regex = try? NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive) else {
            return ""
        }
        
        guard !(shouldRemoveLastDigit && phoneNubmer.count <= 2) else { return "+7" }
        let range = NSString(string: phoneNubmer).range(of: phoneNubmer)
        var number = regex.stringByReplacingMatches(
            in: phoneNubmer,
            options: [],
            range: range,
            withTemplate: ""
        )
        
        if number.count > maxPhoneNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxPhoneNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regularRange = number.startIndex..<maxIndex
        
        if number.count > 1 {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(
                of: pattern,
                with: "$1 ($2) $3-$4-$5",
                options: .regularExpression,
                range: regularRange
            )
        }
        
        phoneNumberTextFieldDelegate?.updatePhoneNumber(number)
        return "+" + number
    }
    
}
