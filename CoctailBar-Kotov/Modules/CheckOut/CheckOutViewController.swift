//
//  CheckOutViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.10.2022.
//

import UIKit
import SnapKit

final class CheckOutViewController: UIViewController {

    private let presenter: CheckOutPresenter

    //MARK: - GestureRecognizer

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.isEnabled = false
        return gesture
    }()

    //MARK: - UI Elements

    private lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "№\(Int.random(in: 000001...999999))"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var summLabel: UILabel = {
        let label = UILabel()
        label.text = "Total price: \(presenter.getTotalSumm())"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var shippingAdressLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping adress: \(presenter.getShippingAdress())"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var userNameTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Enter your name"
        textField.addTarget(
            self,
            action: #selector(userNameTextFieldValueChanged),
            for: .editingChanged
        )
        return textField
    }()

    private lazy var shippingLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping method: "
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var deliveryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Delivery", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 0.4
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(
            self,
            action: #selector(deliveryButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var pickupButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Pickup", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 0.4
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(
            self,
            action: #selector(pickupButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var createOrderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.setTitle("Create order", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(createOrderButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: CheckOutPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.saveOrderNumber(text: orderNumberLabel.text ?? "")
        setupSubviews()
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
        title = "Check Out"
        view.backgroundColor = .white

        view.addSubviews(
            orderNumberLabel,
            summLabel,
            userNameTextField,
            shippingAdressLabel,
            shippingLabel,
            deliveryButton,
            pickupButton,
            createOrderButton
        )
        view.addGestureRecognizer(tapGestureRecognizer)

        configureConstraints()
    }

    private func configureConstraints() {
        orderNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.leading.equalToSuperview().offset(20)
        }
        summLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.trailing.equalToSuperview().inset(20)
        }
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(orderNumberLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        shippingLabel.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        shippingAdressLabel.snp.makeConstraints {
            $0.top.equalTo(shippingLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        deliveryButton.snp.makeConstraints {
            $0.top.equalTo(shippingAdressLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        pickupButton.snp.makeConstraints {
            $0.top.equalTo(deliveryButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        createOrderButton.snp.makeConstraints {
            $0.top.equalTo(pickupButton.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }

    //MARK: - Actions

    @objc private func userNameTextFieldValueChanged() {
        guard let text = userNameTextField.text else { return }
        presenter.saveUserName(text: text)
    }

    @objc private func deliveryButtonTapped() {
        presenter.deliveryButtonTapped()
    }
    @objc private func pickupButtonTapped() {
        presenter.pickupButtonTapped()
    }

    @objc private func createOrderButtonTapped() {
        presenter.successCreateNewOrder()
    }

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

    func updateButtonState(_ isValid: Bool) {
        createOrderButton.isEnabled = isValid
        createOrderButton.backgroundColor = isValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }

    func updateTextViews(text: String, method: Order.ShippingMethod) {
        shippingAdressLabel.text = "Shipping adress: \(text)"
        shippingLabel.text = "Shipping method: \(method)"
    }

    func successNewOrder() {
        orderNumberLabel.text = "№ "
        summLabel.text = "Total price: "
        userNameTextField.text = ""
        shippingAdressLabel.text = "Shipping adress: "
        shippingLabel.text = "Shipping method: "
        createOrderButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        createOrderButton.isEnabled = false
    }

    func saveOrderNumber() {
        guard let text = orderNumberLabel.text else { return }
        presenter.saveOrderNumber(text: text)
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
