//
//  CartViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit
import SnapKit
import MBProgressHUD

final class CartViewController: UIViewController {

    let presenter: CartPresenter

    private var viewModel: CartViewModel?

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
        tableView.register(cellType: CartDrinkCell.self)
        tableView.register(cellType: CartPromocodeCell.self)
        tableView.register(cellType: CartPriceCell.self)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        return tableView
    }()

    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var emptyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "emptyCartImage")
        return image
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 19)
        label.text = "Ooops! Your cart is empty :("
        label.textAlignment = .center
        return label
    }()

    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Go to checkout", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(checkoutButtonTapped),
            for: .touchUpInside
        )
        return button
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

    init(presenter: CartPresenter) {
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
        title = "Cart"
        view.backgroundColor = .systemGray6
        view.addSubviews(tableView, checkoutButton, emptyView)
        view.addGestureRecognizer(tapGestureRecognizer)
        emptyView.addSubviews(emptyImage, emptyLabel, selectCocktailsButton)

        configureConstraints()
    }

    private func configureConstraints() {
        checkoutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(checkoutButton.snp.top)
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(200)
            $0.size.equalTo(300)
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(emptyImage)
        }
        selectCocktailsButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
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

    @objc private func selectCocktailsButtonTapped() {
        presenter.goToSelectDrinks()
    }

    @objc private func checkoutButtonTapped() {
        presenter.goToCheckOut()
    }

    //MARK: - Helpers

    func showLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    func updateViewModel(viewModel: CartViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
        setEmptyView(hasDrinks: viewModel.sections.isEmpty)
    }

    private func setEmptyView(hasDrinks: Bool) {
        tableView.isHidden = hasDrinks
        emptyView.isHidden = !hasDrinks
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

extension CartViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.sections[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel?.sections[indexPath.section].items[indexPath.row] else
        {
            return UITableViewCell()
        }

        switch cellType {
        case let .drink(cellModel):
            let cell: CartDrinkCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cellModel)
            cell.countDrinkChangeHandler = { [weak self] count in
                self?.presenter.drinkCountChanged(count: count, id: cellModel.id)
            }
            return cell
        case let .promocode(cellModel):
            let cell: CartPromocodeCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cellModel)
            cell.promocodeChangeHandler = { [weak self] text in
                self?.presenter.promcodeTextFieldChanged(text)
            }
            return cell
        case let .price(cellModel):
            let cell: CartPriceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: cellModel)
            return cell
        }
    }

}
