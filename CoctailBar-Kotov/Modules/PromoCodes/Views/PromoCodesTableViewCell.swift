//
//  PromoCodesTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 03.08.2022.
//

import UIKit
import SnapKit

final class PromoCodesTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var promoCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var timePromoCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var discountContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        return view
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
            promoCodeLabel,
            timePromoCodeLabel,
            discountContainerView
        )
        discountContainerView.addSubview(discountLabel)
        configureConstraints()
    }

    private func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        discountContainerView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(containerView)
            $0.width.equalTo(100)
        }
        discountLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        promoCodeLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalTo(discountContainerView.snp.trailing).offset(15)
            $0.trailing.equalTo(-10)
        }
        timePromoCodeLabel.snp.makeConstraints {
            $0.top.equalTo(promoCodeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(promoCodeLabel)
            $0.trailing.equalTo(-10)
            $0.bottom.equalTo(-10)
        }
    }

    //MARK: - Configuration

    func configure(with item: PromocodeCellModel) {
        discountLabel.text = item.discount
        discountContainerView.backgroundColor = item.discountType.backgroundColor
        promoCodeLabel.text = item.title
        timePromoCodeLabel.text = item.period
    }

}
