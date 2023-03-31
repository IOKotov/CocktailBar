//
//  TitleHeaderView.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 27.06.2022.
//

import UIKit
import SnapKit

final class TitleHeaderView: UITableViewHeaderFooterView, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    //MARK: - Life Cycle

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Layout

    private func setupSubviews() {
        addSubview(titleLabel)  
        configureConstraints()
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(-8)
        }
    }

    //MARK: - Configuration

    func configure(with title: String) {
        titleLabel.text = title
    }

}
