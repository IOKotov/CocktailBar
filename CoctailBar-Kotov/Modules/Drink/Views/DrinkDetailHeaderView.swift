//
//  DrinkDetailHeaderView.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 10.08.2022.
//

import UIKit
import SnapKit
import Nuke
import ImageViewer_swift

final class DrinkDetailHeaderView: UITableViewHeaderFooterView, ClassIdentifiable {

    private enum Layout {
        static let favoriteImageViewSize: CGSize = .init(width: 25, height: 25)
        static let containerViewSize: CGSize = .init(width: 40, height: 40)
    }

    var addedInFavoritesHandler: (() -> Void)?
    var addedInCartHandler: (() -> Void)?

    //MARK: - UI Elements

    private lazy var drinkImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        return image
    }()

    private lazy var drinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var drinkInstructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var favoriteContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.5
        return view
    }()

    private lazy var favoriteImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "favoritesButtonIcon")
        return image
    }()

    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.addTarget(
            self,
            action: #selector(favoritesButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addToCartIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.5

        button.addTarget(
            self,
            action: #selector(addToCartButtonTapped),
            for: .touchUpInside
        )
        return button
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
        addSubviews(
            drinkImageView,
            drinkLabel,
            drinkInstructionLabel,
            favoriteContainerView,
            addToCartButton
        )
        favoriteContainerView.addSubviews(favoriteImageView, favoritesButton)
        configureConstraints()
    }

    private func configureConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(drinkImageView.snp.width)
        }
        drinkLabel.snp.makeConstraints {
            $0.top.equalTo(drinkImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        drinkInstructionLabel.snp.makeConstraints() {
            $0.top.equalTo(drinkLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(-20)
        }
        favoriteContainerView.snp.makeConstraints() {
            $0.bottom.equalTo(drinkImageView).inset(20)
            $0.trailing.equalTo(drinkImageView).inset(20)
            $0.size.equalTo(Layout.containerViewSize)
        }
        favoriteImageView.snp.makeConstraints() {
            $0.center.equalToSuperview()
            $0.size.equalTo(Layout.favoriteImageViewSize)
        }
        favoritesButton.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        addToCartButton.snp.makeConstraints() {
            $0.bottom.equalTo(drinkImageView).inset(20)
            $0.leading.equalTo(drinkImageView).offset(20)
            $0.size.equalTo(Layout.containerViewSize)
        }
    }

    //MARK: - Actions

    @objc private func favoritesButtonTapped() {
        addedInFavoritesHandler?()
    }

    @objc private func addToCartButtonTapped() {
        addedInCartHandler?()
    }

    //MARK: - Configuration

    func configure(with viewModel: DrinkDetailViewModel) {
        drinkLabel.text = viewModel.drink.name
        drinkInstructionLabel.text = viewModel.drink.instruction
        favoriteImageView.image = viewModel.isFavorite ? UIImage(named: "favoriteImage") : UIImage(named: "favoritesButtonIcon")

        guard let url = URL(string: viewModel.drink.imageURL) else { return }
        Nuke.loadImage(with: url, into: drinkImageView)
        drinkImageView.setupImageViewer(url: url)
    }

}
