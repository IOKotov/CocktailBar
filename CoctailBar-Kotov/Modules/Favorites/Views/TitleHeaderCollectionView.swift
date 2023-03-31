//
//  TitleHeaderCollectionView.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 04.08.2022.
//

import UIKit
import SnapKit

final class TitleHeaderCollectionView: UICollectionReusableView, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Layout

    private func setupSubviews() {
        backgroundColor = .white
        addSubview(titleLabel)
        configureConstraints()
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(10)
        }
    }

    //MARK: - Configuration

    func configure(with title: String) {
        titleLabel.text = title
    }

}
