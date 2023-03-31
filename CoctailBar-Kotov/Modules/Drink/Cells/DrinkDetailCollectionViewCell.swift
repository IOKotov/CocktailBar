//
//  DrinkDetailCollectionViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 10.08.2022.
//

import UIKit

final class DrinkDetailCollectionViewCell: UITableViewCell, ClassIdentifiable {

    private enum Layout {
        static let imageViewSize: CGSize = .init(width: 150, height: 150)
        static let collectionViewInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    private var ingredientsImageURL: [String?] = []

    //MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: DrinkDetailViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
        contentView.addSubviews(collectionView)

        configureConstraints()
    }

    func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Layout.imageViewSize.height)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    //MARK: - Configure

    func configure(ingredientsImageURL: [String?]) {
        self.ingredientsImageURL = ingredientsImageURL
        collectionView.reloadData()
    }

}

//MARK: - UICollectionViewDataSource

extension DrinkDetailCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ingredientsImageURL.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = ingredientsImageURL[indexPath.item]
        let cell: DrinkDetailViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: url ?? "")
        return cell
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension DrinkDetailCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Layout.imageViewSize.height - Layout.collectionViewInsets.top - Layout.collectionViewInsets.bottom
        return .init(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Layout.collectionViewInsets
    }

}
