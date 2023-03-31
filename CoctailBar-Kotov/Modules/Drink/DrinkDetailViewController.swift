//
//  DrinkDetailViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 06.07.2022.
//

import UIKit
import Nuke
import SnapKit
import MBProgressHUD

final class DrinkDetailViewController: UIViewController {

    private let presenter: DrinkDetailPresenter

    private var viewModel: DrinkDetailViewModel?

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellType: DrinkDetailTableViewCell.self)
        tableView.register(cellType: DrinkDetailCollectionViewCell.self)
        tableView.registerHeaderFooterView(viewType: DrinkDetailHeaderView.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    //MARK: - Life Cycle

    init(presenter: DrinkDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        presenter.loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    //MARK: - Layout

    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        configureConstraints()
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Helpers

    func showLoader() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func hideLoader() {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func updateData(viewModel: DrinkDetailViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

}

//MARK: - UITableViewDataSource

extension DrinkDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cellModel = viewModel.items[indexPath.row]

        switch cellModel {
        case let .ingredientImage(ingredientsImageURL):
            let cell: DrinkDetailCollectionViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(ingredientsImageURL: ingredientsImageURL)
            return cell
        case let .ingredient(name, measure):
            let cell: DrinkDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: name, measure: measure)
            return cell
        }
    }

}

//MARK: - UITableViewDelegate

extension DrinkDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return nil }
        let headerView: DrinkDetailHeaderView = tableView.dequeueReusableHeaderFooterView()
        headerView.configure(with: viewModel)
        headerView.addedInFavoritesHandler = { [weak self] in
            self?.presenter.didSelectFavoriteDrink(id: viewModel.drink.id)
        }
        headerView.addedInCartHandler = { [weak self] in
            self?.presenter.didSelectDrinkToCart(id: viewModel.drink.id)
        }
        return headerView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }

}
