//
//  RandomDrinksTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.07.2022.
//

import UIKit
import Nuke
import SnapKit

protocol RandomDrinkCellDelegate: AnyObject {
    func didSelectRandomDrink(id: String)
}

final class RandomDrinksTableViewCell: UITableViewCell, ClassIdentifiable {

    private enum Layout {
        static let imageViewSize: CGSize = .init(width: 150, height: 150)
        static let collectionViewInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    var reloadDataHandler: (() -> Void)?

    weak var delegate: RandomDrinkCellDelegate?

    private var drinks: [DrinkCellModel] = []
    private var favoriteDrinks: [String] = []

    //MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: RandomDrinkCell.self)
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
        backgroundColor = .systemBlue
        contentView.addSubviews(collectionView)

        configureConstraints()
    }

    func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(Layout.imageViewSize.height)
        }
    }

    //MARK: - Configure

    func configure(drinks: [DrinkCellModel]) {
        self.drinks = drinks
        collectionView.reloadData()
    }

}

//MARK: - UICollectionViewDataSource

extension RandomDrinksTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        drinks.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RandomDrinkCell = collectionView.dequeueReusableCell(for: indexPath)
        let cellModel = drinks[indexPath.item]
        cell.configure(with: cellModel.drink.imageURL, isFavorite: cellModel.isFavorite)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        let id = drinks[indexPath.item].drink.id
        delegate.didSelectRandomDrink(id: id)
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension RandomDrinksTableViewCell: UICollectionViewDelegateFlowLayout {

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
