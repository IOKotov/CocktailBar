//
//  CartPriceCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit
import SnapKit

final class CartPriceCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var priceDescriptionLabel: UILabel = {
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
            priceDescriptionLabel,
            priceLabel
        )
        configureConstraints()
    }

    private func configureConstraints() {
        priceDescriptionLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(20)
        }
    }

    //MARK: - Configuration

    func configure(with cellModel: CartPriceCellModel) {
        priceDescriptionLabel.text = cellModel.title
        priceLabel.text = cellModel.price
    }

}

