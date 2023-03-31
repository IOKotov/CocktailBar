//
//  OrderTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import UIKit
import SnapKit

final class OrderTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var numberLabel: UILabel = {
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
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var shippingMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
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
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubviews(
        numberLabel,
        priceLabel,
        nameLabel,
        adressLabel,
        shippingMethodLabel
        )
        configureConstraints()
    }

    private func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        adressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        shippingMethodLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    //MARK: - Configuration

    func configure(with item: OrderCellModel) {
        numberLabel.text = item.orderNumber
        priceLabel.text = item.totalPrice
        nameLabel.text = item.userName
        adressLabel.text = item.userAdress
        shippingMethodLabel.text = "\(item.shippingMethod)"
    }

}

