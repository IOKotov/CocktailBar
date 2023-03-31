//
//  AuthorizationViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 18.07.2022.
//

import UIKit
import SnapKit

final class AuthorizationViewController: UIViewController {

    private let presenter: AuthorizationPresenter

    //MARK: - GestureRecognizer

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.isEnabled = false
        return gesture
    }()

    //MARK: - UI Elements

    private lazy var scrollView = UIScrollView()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        button.setTitle("Enter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private lazy var sendSmsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        button.setTitle("Send sms code", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(sendSmsButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private lazy var phoneNumberTextField: BaseTextField = {
        let textField = PhoneNumberTextField()
        textField.phoneNumberTextFieldDelegate = presenter
        return textField
    }()

    private lazy var smsCodeTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Enter your code here"
        textField.addTarget(
            self,
            action: #selector(codeTextFieldValueChanged),
            for: .editingChanged
        )
        return textField
    }()

    //MARK: - Life Cycle

    init(presenter: AuthorizationPresenter) {
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
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubviews(
            signInButton,
            sendSmsButton,
            phoneNumberTextField,
            smsCodeTextField
        )
        view.addGestureRecognizer(tapGestureRecognizer)

        configureConstraints()
    }

    private func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.width.equalTo(view)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(200)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        smsCodeTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        sendSmsButton.snp.makeConstraints {
            $0.top.equalTo(smsCodeTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        signInButton.snp.makeConstraints {
            $0.top.equalTo(sendSmsButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.bottom.lessThanOrEqualTo(scrollView.contentLayoutGuide).inset(20)
        }
    }

    //MARK: - Actions

    @objc private func sendSmsButtonTapped() {
        presenter.generateNotification()
    }

    @objc private func signInButtonTapped() {
        presenter.enterAuthorizationButton()
    }
    
    @objc private func phoneNumberTextFieldValueChanged() {
        presenter.phoneNumberTextFieldChanged(phoneNumberTextField.text)
    }
    
    @objc private func codeTextFieldValueChanged() {
        presenter.codeTextFieldChanged(smsCodeTextField.text)
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

    func updateSignInButtonState(_ isValid: Bool) {
        signInButton.isEnabled = isValid
        signInButton.backgroundColor = isValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }

    func updateSendSmsButtonState(_ isValid: Bool) {
        sendSmsButton.isEnabled = isValid
        sendSmsButton.backgroundColor = isValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
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
