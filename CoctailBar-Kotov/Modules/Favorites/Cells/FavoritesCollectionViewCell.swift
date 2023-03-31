//
//  FavoritesCollectionViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 04.08.2022.
//

import UIKit
import Nuke
import SnapKit

final class FavoritesCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    static let prototype: FavoritesCollectionViewCell = .init()

    //MARK: - UI Elements

    private lazy var drinkImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.numberOfLines = 2
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
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        contentView.addSubviews(
            drinkImageView,
            titleLabel
        )
        configureConstraints()
    }

    private func configureConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(drinkImageView.snp.width)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(drinkImageView.snp.bottom).offset(5)
            $0.centerX.equalTo(drinkImageView)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(30)
            $0.bottom.equalTo(-10)
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 5
        height += size.width - 10
        height += 5
        height += 30
        height += 10
        return .init(width: size.width, height: height)
    }

    //MARK: - Configuration

    func configure(with title: String, imageURL: String) {
        titleLabel.text = title

        guard let url = URL(string: imageURL) else { return }
        Nuke.loadImage(with: url, into: drinkImageView)
    }

}
