//
//  DrinksViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 21.06.2022.
//

import UIKit
import MBProgressHUD
import Nuke
import SnapKit

final class DrinksViewController: UIViewController {

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellType: DrinkTableViewCell.self)
        tableView.register(cellType: RandomDrinksTableViewCell.self)
        tableView.registerHeaderFooterView(viewType: TitleHeaderView.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: .init(x: .zero, y: .zero, width: 1, height: 1))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let presenter: DrinksPresenter

    private var viewModel: DrinksViewModel?

    //MARK: - Life Cycle

    init(_ presenter: DrinksPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        presenter.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Drinks"
        view.backgroundColor = .white
        view.addSubview(tableView)

        configureConstraints()
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Actions

    @objc private func filterButtonTapped() {
        presenter.filterButtonAction()
    }

    //MARK: - Helpers

    func showLoader() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func hideLoader() {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func updateData(viewModel: DrinksViewModel) {
        self.viewModel = viewModel
        updateNavigationBarItem()
        tableView.reloadData()
    }

    //MARK: - Private Helpers

    private func updateNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: viewModel?.filterIcon,
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
    }

}

//MARK: - UITableViewDataSource

extension DrinksViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.sections.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel?.sections[section].kind {
        case .random:
            return 1
        case .drinks:
            return viewModel?.sections[section].items.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[indexPath.section] else {
            return UITableViewCell()
        }

        switch section.kind {
        case .random:
            let cell: RandomDrinksTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(drinks: section.items)
            cell.delegate = self
            return cell
        case .drinks:
            let cell: DrinkTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let drink = section.items[indexPath.row].drink
            let isFavorite = section.items[indexPath.row].isFavorite
            cell.configure(with: drink.name, imageURL: drink.imageURL, isFavorite: isFavorite)
            return cell
        }
    }

}

//MARK: - UITableViewDelegate

extension DrinksViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel?.sections[section].kind == .drinks else { return nil }
        let header: TitleHeaderView = tableView.dequeueReusableHeaderFooterView()
        header.configure(with: viewModel?.sections[section].title ?? "")
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let drinkId = viewModel?.sections[indexPath.section].items[indexPath.row].drink.id else
        { return }
        presenter.didSelectItem(with: drinkId)
    }

}

//MARK: - RandomDrinksTableViewCellDelegate

extension DrinksViewController: RandomDrinkCellDelegate {

    func didSelectRandomDrink(id: String) {
        presenter.didSelectItem(with: id)
    }

}
