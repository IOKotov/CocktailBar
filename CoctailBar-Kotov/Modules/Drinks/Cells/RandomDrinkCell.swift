//
//  RandomDrinkCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.07.2022.
//

import UIKit
import Nuke
import SnapKit

final class RandomDrinkCell: UICollectionViewCell, ClassIdentifiable {

    private enum Layout {
        static let favoriteImageViewSize: CGSize = .init(width: 16, height: 16)
        static let containerViewSize: CGSize = .init(width: 26, height: 26)
    }

    //MARK: - UI Elements

    private lazy var drinkImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()

    private lazy var favoriteImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "favoriteImage")
        return image
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = drinkImageView.layer.cornerRadius/2
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.5
        return view
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
        contentView.addSubviews(drinkImageView,containerView)
        containerView.addSubview(favoriteImageView)
        configureConstraints()
    }

    private func configureConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(7)
            $0.size.equalTo(Layout.containerViewSize)
        }
        favoriteImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Layout.favoriteImageViewSize)
        }
    }

    //MARK: - Configuration

    func configure(with imageURL: String, isFavorite: Bool) {
        containerView.isHidden = !isFavorite

        guard let url = URL(string: imageURL) else { return }
        Nuke.loadImage(with: url, into: drinkImageView)
    }

}
