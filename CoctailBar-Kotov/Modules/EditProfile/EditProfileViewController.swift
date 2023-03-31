//
//  EditProfileViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit

final class EditProfileViewController: UIViewController {

    private let presenter: EditProfilePresenter

    //MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var changeNicknameButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(changeNicknameButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.minimumFontSize = 15
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.returnKeyType = UIReturnKeyType.done
        textField.placeholder = "Enter a new User name"
        textField.addTarget(
            self,
            action: #selector(loginTextFieldValueChanged),
            for: .editingChanged
        )
        return textField
    }()

    //MARK: - Life Cycle

    init(presenter: EditProfilePresenter) {
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
        title = "EditProfile"
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubviews(
            nicknameTextField,
            changeNicknameButton
        )
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
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(70)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        changeNicknameButton.snp.makeConstraints{
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.bottom.lessThanOrEqualTo(scrollView.contentLayoutGuide).inset(20)
        }
    }

    //MARK: - Actions

    @objc private func changeNicknameButtonTapped() {
        presenter.enterChangeButton()
    }

    @objc private func loginTextFieldValueChanged() {
        presenter.nicknameTextFieldChanged(nicknameTextField.text)
    }

    @objc private func keyboardWillShow() {
        print(#function)
    }

    @objc private func keyboardWillHide() {
        print(#function)
    }

    //MARK: - Helpers

    func updateChangeNicknameButtonState(_ isValid: Bool) {
        changeNicknameButton.isEnabled = isValid
        changeNicknameButton.backgroundColor = isValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }

    func updateUserNameTextField(text: String) {
        nicknameTextField.text = text
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
