//
//  ProfileViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    var viewModel: ProfileViewModel?

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(cellType: ProfileTableViewCell.self)
        tableView.registerHeaderFooterView(viewType: ProfileHeaderView.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        return tableView
    }()

    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed.withAlphaComponent(0.9)
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }()

    let presenter: ProfilePresenter

    //MARK: - Life Cycle

    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        presenter.viewDidLoad()
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Profile"
        view.backgroundColor = .systemGray6
        view.addSubviews(tableView, logOutButton)
        configureConstraints()
    }

    private func configureConstraints() {
        logOutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(logOutButton.snp.top)
        }
    }

    //MARK: - Actions

    @objc private func logOutButtonTapped() {
        presenter.logOutAction()
    }

    //MARK: - Helpers

    func updateViewModel(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

}

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.section[section].items.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cellType = viewModel.section[indexPath.section].items[indexPath.row].cellType
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: cellType.title, image: cellType.icon)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}

//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return nil }
        let header: ProfileHeaderView = tableView.dequeueReusableHeaderFooterView()
        header.configure(
            with: viewModel.userName,
            points: viewModel.points,
            avatarURLString: viewModel.avatarURLString
        )
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.routingOnScreenProfile(indexPath: indexPath)
    }

}
