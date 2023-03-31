//
//  PromoCodesViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit

final class PromoCodesViewController: UIViewController {

    private var cellModels: [PromocodeCellModel] = []

    private let presenter: PromoCodesPresenter

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(cellType: PromoCodesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        return tableView
    }()

    private lazy var emptyView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var emptyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "emptyPromocodesImage")
        return image
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 19)
        label.text = "You haven't promo codes. Please add it."
        label.textAlignment = .center
        return label
    }()

    private lazy var addPromocodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Adding promo code now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(addPromocodeButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: PromoCodesPresenter) {
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
        title = "Promo Codes"
        view.backgroundColor = .systemGray6
        view.addSubviews(tableView, emptyView)
        emptyView.addSubviews(emptyImage, emptyLabel, addPromocodeButton)

        configureConstraints()
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints {
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
        addPromocodeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }

    //MARK: - Actions

    @objc private func addPromoCodes() {
        presenter.didSelectAddPromocodes()
    }

    @objc private func addPromocodeButtonTapped() {
        presenter.didSelectAddPromocodes()
    }

    //MARK: - Helpers

    func updateViewModel(cellModels: [PromocodeCellModel]) {
        self.cellModels = cellModels
        tableView.reloadData()
        setEmptyView(hasPromocodes: !cellModels.isEmpty)
    }

    private func setEmptyView(hasPromocodes: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = hasPromocodes ? 1 : 0
            self.emptyView.alpha = hasPromocodes ? 0 : 1
            if self.tableView.alpha == 1 {
                self.updateNavigationBarItem()
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }

    //MARK: - Private Helpers

    private func updateNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "addPromoCodesIcon")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(addPromoCodes)
        )
    }

}

//MARK: - UITableViewDataSource

extension PromoCodesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PromoCodesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let item = cellModels[indexPath.row]
        cell.configure(with: item)
        return cell
    }

}

//MARK: - UITableViewDelegate

extension PromoCodesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let id = self.cellModels[indexPath.row].id
            self.presenter.deletePromocodeAt(id)
            self.cellModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.setEmptyView(hasPromocodes: !self.cellModels.isEmpty)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = self.cellModels[indexPath.row].id
        presenter.didSelectChangePromocode(id)
    }

}
