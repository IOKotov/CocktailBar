//
//  OrderViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import UIKit
import SnapKit

final class OrderViewController: UIViewController {
    
    private var cellModels: [OrderCellModel] = []

    private let presenter: OrderPresenter

    //MARK: - GestureRecognizer

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.isEnabled = false
        return gesture
    }()

    //MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(cellType: OrderTableViewCell.self)
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
        image.image = UIImage(named: "emptyOrderImage")
        return image
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 19)
        label.text = "You haven't orders. Lets go shopping!"
        label.textAlignment = .center
        return label
    }()

    //MARK: - Life Cycle

    init(presenter: OrderPresenter) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        registerKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unregisterKeyboardNotification()
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Order"
        view.backgroundColor = .white

        view.addGestureRecognizer(tapGestureRecognizer)

        view.addSubviews(tableView, emptyView)
        emptyView.addSubviews(emptyImage, emptyLabel)

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
    }

    //MARK: - Actions

    @objc private func viewTapped() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow() {
        tapGestureRecognizer.isEnabled = true
    }

    @objc private func keyboardWillHide() {
        tapGestureRecognizer.isEnabled = false
    }

    //MARK: - Helpers

    func updateViewModel(cellModels: [OrderCellModel]) {
        self.cellModels = cellModels
        tableView.reloadData()
        setEmptyView(hasOrder: !cellModels.isEmpty)
    }

    private func setEmptyView(hasOrder: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = hasOrder ? 1 : 0
            self.emptyView.alpha = hasOrder ? 0 : 1
        }
    }

    //MARK: - Private Helpers

    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

}

//MARK: - UITableViewDataSource

extension OrderViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        let item = cellModels[indexPath.row]
        cell.configure(with: item)
        return cell
    }

}

//MARK: - UITableViewDataSource

extension OrderViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let orderNumber = self.cellModels[indexPath.row].orderNumber
            self.presenter.deleteOrders(orderNumber)
            self.cellModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.setEmptyView(hasOrder: !self.cellModels.isEmpty)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
