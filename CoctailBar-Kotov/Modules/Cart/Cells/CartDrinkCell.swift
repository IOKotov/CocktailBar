//
//  CartDrinkCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit
import Nuke
import SnapKit

final class CartDrinkCell: UITableViewCell, ClassIdentifiable {

    private enum Layout {
        static let imageViewSize: CGSize = .init(width: 100, height: 100)
    }

    var countDrinkChangeHandler: ((Int) -> Void)?

    //MARK: - UI Elements

    private lazy var drinkImageView : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        return image
    }()

    private lazy var drinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 19)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var categoryDrinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var countDrinkTextField: UITextField = {
        let textField = UITextField()
        textField.minimumFontSize = 17
        textField.textAlignment = .center
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.addTarget(
            self,
            action: #selector(countDrinkTextFieldValueChanged),
            for: .editingDidEnd
        )
        return textField
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusDrinkIcon"), for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(plusButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minusDrinkIcon"), for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(minusButtonTapped),
            for: .touchUpInside
        )
        return button
    }()


    private let minValue = 1
    private let maxValue = 100
    private lazy var valuesRange = minValue...maxValue

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
        contentView.addSubviews(
            drinkImageView,
            drinkLabel,
            categoryDrinkLabel,
            priceLabel,
            countDrinkTextField,
            plusButton,
            minusButton
        )
        configureConstraints()
    }

    private func configureConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(Layout.imageViewSize)
        }
        drinkLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(-5)
        }
        categoryDrinkLabel.snp.makeConstraints {
            $0.top.equalTo(drinkLabel.snp.bottom).offset(10)
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(-5)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(20)
            $0.bottom.equalTo(-20)
        }
        countDrinkTextField.snp.makeConstraints {
            $0.trailing.equalTo(-40)
            $0.bottom.equalTo(-20)
            $0.width.equalTo(60)
        }
        minusButton.snp.makeConstraints {
            $0.trailing.equalTo(countDrinkTextField.snp.leading).inset(-10)
            $0.centerY.equalTo(countDrinkTextField)
            $0.size.equalTo(20)
        }
        plusButton.snp.makeConstraints {
            $0.leading.equalTo(countDrinkTextField.snp.trailing).offset(10)
            $0.centerY.equalTo(countDrinkTextField)
            $0.size.equalTo(20)
        }
    }

    //MARK: - Actions

    @objc private func countDrinkTextFieldValueChanged() {
        countDrinksChanged()
    }

    @objc private func plusButtonTapped() {
        countDrinksChanged(value: 1)
    }

    @objc private func minusButtonTapped() {
        countDrinksChanged(value: -1)
    }

    //MARK: - Configuration

    func configure(with cellModel: CartDrinkCellModel) {
        drinkLabel.text = cellModel.name
        categoryDrinkLabel.text = cellModel.categoryName
        priceLabel.text = "\(cellModel.price)"
        countDrinkTextField.text = "\(cellModel.count)"

        guard let url = URL(string: cellModel.imageUrlString ?? "") else { return }
        Nuke.loadImage(with: url, into: drinkImageView)
    }

    //MARK: - Private Helpers

    private func countDrinksChanged(value: Int = 0) {
        guard let text = countDrinkTextField.text, let count = Int(text) else { return }
        countDrinkChangeHandler?(count + value)
    }

}

//MARK: - UITextFieldDelegate

extension CartDrinkCell: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let enterText = NSString(string: textField.text ?? "").replacingCharacters(
            in: range, with: string
        )
        guard !enterText.isEmpty else { return true }
        return valuesRange.contains(Int(enterText) ?? 0)
    }

}
