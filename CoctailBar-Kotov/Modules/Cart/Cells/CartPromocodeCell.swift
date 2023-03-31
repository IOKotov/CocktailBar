//
//  CartPromocodeCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit
import SnapKit

final class CartPromocodeCell: UITableViewCell, ClassIdentifiable {
    
    var promocodeChangeHandler: ((String) -> Void)?

    //MARK: - UI Elements

    private lazy var promocodeTextField: UITextField = {
        let textField = UITextField()
        textField.minimumFontSize = 17
        textField.textAlignment = .left
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.returnKeyType = .done
        textField.placeholder = "Type promo code in"
        textField.addTarget(
            self,
            action: #selector(promocodeTextFieldValueChanged),
            for: [.editingDidEndOnExit, .editingDidEnd]
        )
        return textField
    }()

    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Layout

    private func setupSubviews() {
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(promocodeTextField)

        configureConstraints()
    }

    private func configureConstraints() {
        promocodeTextField.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(20)
        }
    }

    //MARK: - Actions

    @objc private func promocodeTextFieldValueChanged() {
        guard let text = promocodeTextField.text else { return }
        promocodeChangeHandler?(text)
    }

    //MARK: - Configuration

    func configure(with cellModel: CartPromocodeCellModel) {
        promocodeTextField.text = cellModel.promocode
    }

}
