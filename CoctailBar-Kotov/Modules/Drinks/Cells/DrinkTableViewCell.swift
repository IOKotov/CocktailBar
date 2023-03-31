//
//  DrinkTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 27.06.2022.
//

import UIKit
import Nuke
import SnapKit

final class DrinkTableViewCell: UITableViewCell, ClassIdentifiable {

    private enum Layout {
        static let imageViewSize: CGSize = .init(width: 52, height: 52)
        static let favoriteImageViewSize: CGSize = .init(width: 16, height: 16)
    }

    //MARK: - UI Elements

    private lazy var drinkImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var favoriteImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "favoriteImage")
        return image
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
        contentView.addSubviews(drinkImageView, titleLabel, favoriteImageView)
        
        configureConstraints()
    }

    private func configureConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Layout.imageViewSize)
        }
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(26)
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(drinkImageView)
        }
        favoriteImageView.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Layout.favoriteImageViewSize)
        }
    }

    //MARK: - Configuration

    func configure(with title: String, imageURL: String, isFavorite: Bool) {
        titleLabel.text = title
        favoriteImageView.isHidden = !isFavorite

        guard let url = URL(string: imageURL) else { return }
        Nuke.loadImage(with: url, into: drinkImageView)
    }

}
