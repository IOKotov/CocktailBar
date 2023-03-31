//
//  DrinkDetailTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 10.08.2022.
//

import UIKit
import SnapKit

final class DrinkDetailTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var drinkIngredientLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var measureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
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
        selectionStyle = .none
        contentView.addSubviews(
            drinkIngredientLabel,
            measureLabel
        )
        configureConstraints()
    }

    private func configureConstraints() {
        drinkIngredientLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(20)
        }
        measureLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(20)
        }
    }

    //MARK: - Configuration

    func configure(with name: String, measure: String) {
        drinkIngredientLabel.text = name
        measureLabel.text = measure
    }

}
