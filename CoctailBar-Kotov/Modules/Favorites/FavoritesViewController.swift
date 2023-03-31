//
//  FavoritesViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit
import MBProgressHUD

final class FavoritesViewController: UIViewController {

    private var viewModel: FavoritesViewModel?

    private let presenter: FavoritesPresenter

    private enum Layout {
        static let itemsPerRow: CGFloat = 3
        static let minimumItemSpacing: CGFloat = 8
        static let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        static let collectionViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    //MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: FavoritesCollectionViewCell.self)
        collectionView.register(TitleHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private lazy var emptyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "emptyFavoritesImage")
        return image
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 19)
        label.text = "You haven't favorites drinks yet :("
        label.textAlignment = .center
        return label
    }()

    private lazy var selectCocktailsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Select cocktails", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(selectCocktailsButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: FavoritesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        presenter.loadData()
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Favorites"
        view.backgroundColor = .white
        view.addSubviews(collectionView, emptyView)
        emptyView.addSubviews(emptyImage, emptyLabel, selectCocktailsButton)
        configureConstraints()
    }

    func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(300)
            $0.size.equalTo(100)
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        selectCocktailsButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }

    //MARK: - Actions

    @objc private func selectCocktailsButtonTapped() {
        presenter.goToSelectDrinks()
    }

    //MARK: - Helpers

    func showLoader() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func hideLoader() {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func updateViewModel(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
        setEmptyView(hasDrinks: !viewModel.sections.isEmpty)
    }

    private func setEmptyView(hasDrinks: Bool) {
        collectionView.isHidden = !hasDrinks
        emptyView.isHidden = hasDrinks
    }

}

//MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel else { return UICollectionReusableView() }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: TitleHeaderCollectionView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "headerView",
                for: indexPath
            ) as! TitleHeaderCollectionView

            let section = viewModel.sections[indexPath.section]
            headerView.configure(with: "\(section.title): \(section.items.count)")
            return headerView
        }
       return UICollectionReusableView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel?.sections[section].items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let cell: FavoritesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item.title , imageURL: item.imageURLString)
        return cell
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        let paddingSpace = Layout.sectionInsets.left + Layout.sectionInsets.right + Layout.minimumItemSpacing * (Layout.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let width = availableWidth / Layout.itemsPerRow

        let title = viewModel.sections[indexPath.section].items[indexPath.item].title
        let cell = FavoritesCollectionViewCell.prototype
        cell.configure(with: title, imageURL: "")
        return cell.sizeThatFits(.init(width: width, height: .greatestFiniteMagnitude))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Layout.collectionViewInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel?.sections[indexPath.section].items[indexPath.row].id else { return }
        presenter.didSelectItem(with: id)
    }

}
