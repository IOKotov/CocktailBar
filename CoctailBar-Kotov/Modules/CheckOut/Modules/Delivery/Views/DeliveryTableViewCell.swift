//
//  DeliveryTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 02.11.2022.
//

import UIKit
import SnapKit

final class DeliveryTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var adressSuggsesionLabel: UILabel = {
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
        contentView.addSubview(adressSuggsesionLabel)
        configureConstraints()
    }

    private func configureConstraints() {
        adressSuggsesionLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(20)
        }
    }

    //MARK: - Configuration

    func configure(with adress: String) {
        adressSuggsesionLabel.text = adress
    }

}
