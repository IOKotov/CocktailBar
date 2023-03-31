//
//  DeliveryViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 26.10.2022.
//

import UIKit
import SnapKit

final class DeliveryViewController: UIViewController {

    private let presenter: DeliveryPresenter
    private var suggessions: [Suggestion] = []

    //MARK: - UI Elements

    private lazy var adressTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Enter adress"
        textField.addTarget(
            self,
            action: #selector(adressTextFieldValueChanged),
            for: .editingChanged
        )
        return textField
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellType: DeliveryTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: .init(x: .zero, y: .zero, width: 1, height: 1))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Confim", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(confirmButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: DeliveryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    //MARK: - Layout

    private func setupSubviews() {
        title = "Delivery"
        view.backgroundColor = .white

        view.addSubviews(
            tableView,
            adressTextField,
            confirmButton
        )

        configureConstraints()
    }

    private func configureConstraints() {
        adressTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(adressTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
    }

    //MARK: - Actions

    @objc private func adressTextFieldValueChanged() {
        guard let text = adressTextField.text else { return }
        guard text.isEmpty else {
            tableView.isHidden = false
            presenter.adressTextFieldValueChanged(text)
            return
        }
        tableView.isHidden = true
    }

    @objc private func confirmButtonTapped() {
        guard let text = adressTextField.text else { return }
        let method = Order.ShippingMethod.delivery
        presenter.confirmButtonTapped(text, method)
    }

    //MARK: - Helpers

    func updateSuggsessions(with suggessions: [Suggestion]) {
        self.suggessions = suggessions
        tableView.reloadData()
    }

    func updateTextFieldText(suggestion: String) {
        adressTextField.text = suggestion
    }

}

//MARK: - UITableViewDataSource

extension DeliveryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggessions.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeliveryTableViewCell = tableView.dequeueReusableCell(withCellType: DeliveryTableViewCell.self)
        cell.configure(with: suggessions[indexPath.row].value)
        return cell
    }

}

//MARK: - UITableViewDelegate

extension DeliveryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let suggestion = suggessions[indexPath.row].value
        presenter.didSelectSuggsession(suggestion)
    }

}
