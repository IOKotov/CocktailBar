//
//  FiltersViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 28.06.2022.
//

import UIKit
import SnapKit

final class FiltersViewController: UIViewController {

    private let initialSelectedCategories: [String]
    private var selectedCategories: [String] = []
    private var categories: [CategoryName] = []

    private let presenter: FiltersPresenter

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellType: FilterTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: .init(x: .zero, y: .zero, width: 1, height: 1))
        return tableView
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Apply Filter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(applyFilterButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: FiltersPresenter, categories: [CategoryName], selectedCategories: [String]) {
        self.presenter = presenter
        self.categories = categories
        self.selectedCategories = selectedCategories
        initialSelectedCategories = selectedCategories
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()

        configureApplyFilterButton(isActive: selectedCategories.isEmpty)
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Filters"
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(filterButton)

        configureConstraints()
    }

    private func configureConstraints() {
        filterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(filterButton.snp.top)
        }
    }

    //MARK: - Actions

    @objc private func applyFilterButtonTapped() {
        presenter.applyFilterButtonAction()
    }

    //MARK: - Private Helpers

    private func configureApplyFilterButton(isActive: Bool) {
        filterButton.isUserInteractionEnabled = isActive
        filterButton.backgroundColor = isActive ? .systemBlue : .systemBlue.withAlphaComponent(0.5)
    }

}

//MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCell(
            withCellType: FilterTableViewCell.self
        )

        let isSelected = selectedCategories.contains(where: {
            $0 == categories[indexPath.row].name
        })

        cell.configure(with: categories[indexPath.row].name)
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedCategory = categories[indexPath.row]

        if selectedCategories.contains(where: { $0 == selectedCategory.name }) {
            selectedCategories = selectedCategories.filter { $0 != selectedCategory.name }
        } else {
            selectedCategories.append(selectedCategory.name)
        }

        presenter.updateSelectedCategories(selectedCategories)

        configureApplyFilterButton(
            isActive: !selectedCategories.difference(from: initialSelectedCategories).isEmpty
        )

        tableView.reloadData()
    }

}
