//
//  FilterTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 28.06.2022.
//

import UIKit
import SnapKit

final class FilterTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
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
        contentView.addSubview(titleLabel)
        selectionStyle = .none

        configureConstraints()
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    //MARK: - Configuration

    func configure(with title: String) {
        titleLabel.text = title
    }

}
