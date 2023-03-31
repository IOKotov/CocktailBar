//
//  BaseTextfield.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 09.09.2022.
//

import UIKit

class BaseTextField: UITextField {

    init() {
        super.init(frame: .zero)

        adjustsFontSizeToFitWidth = true
        minimumFontSize = 14
        textAlignment = .left
        borderStyle = UITextField.BorderStyle.roundedRect
        returnKeyType = UIReturnKeyType.done
        autocorrectionType = .no
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
