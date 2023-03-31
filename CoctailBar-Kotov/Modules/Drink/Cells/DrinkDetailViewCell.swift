//
//  DrinkDetailViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 10.08.2022.
//

import UIKit
import Nuke
import SnapKit
import ImageViewer_swift

final class DrinkDetailViewCell: UICollectionViewCell, ClassIdentifiable {

    private enum Layout {
        static let imageViewSize: CGSize = .init(width: 30, height: 30)
    }

    //MARK: - UI Elements

    private lazy var ingredientImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
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
        contentView.addSubview(ingredientImageView)
        configureConstraints()
    }

    private func configureConstraints() {
        ingredientImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Configuration

    func configure(with urlString: String) {
        guard let url = URL(string: urlString.addingPercentEncoding(
            withAllowedCharacters: .urlFragmentAllowed) ?? urlString
        ) else { return }
        Nuke.loadImage(with: url, into: ingredientImageView)
        ingredientImageView.setupImageViewer(url: url)
    }

}
