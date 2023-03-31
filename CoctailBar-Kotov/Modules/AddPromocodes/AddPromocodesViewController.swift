//
//  AddPromocodesViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.09.2022.
//

import UIKit
import SnapKit

final class AddPromocodesViewController: UIViewController {

    private let presenter: AddPromocodesPresenter
    
    private enum Layout {
        static let textFieldWidth: CGFloat = 175
        static let labelWidth: CGFloat = 100
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    //MARK: - GestureRecognizer

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.isEnabled = false
        return gesture
    }()

    //MARK: - UI Elements

    private lazy var scrollView = UIScrollView()

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private lazy var promocodeTextField: PromocodeTextField = {
        let textField = PromocodeTextField()
        textField.promocodeTextfieldDelegate = presenter
        return textField
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 14
        textField.textAlignment = .left
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = .numberPad
        textField.addTarget(
            self,
            action: #selector(amountTextFieldValueChanged),
            for: .editingChanged
        )
        return textField
    }()

    private lazy var startExpirationTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 14
        textField.textAlignment = .center
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.returnKeyType = UIReturnKeyType.done
        textField.placeholder = "start"
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        return textField
    }()

    private lazy var endExpirationTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 14
        textField.textAlignment = .center
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.returnKeyType = UIReturnKeyType.done
        textField.placeholder = "end"
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        return textField
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()

    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        toolBar.setItems([doneButton], animated: false)
        return toolBar
    }()

    private lazy var promocodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Promocode"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.text = "Expiration"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    //MARK: - Life Cycle

    init(presenter: AddPromocodesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        presenter.loadView()
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
        view.backgroundColor = .systemGray6
        view.addSubview(scrollView)
        scrollView.addSubviews(
            promocodeTextField,
            promocodeLabel,
            amountTextField,
            amountLabel,
            startExpirationTextField,
            endExpirationTextField,
            expirationLabel,
            createButton
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
        promocodeLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(50)
            $0.leading.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(Layout.labelWidth)
        }
        promocodeTextField.snp.makeConstraints {
            $0.top.equalTo(promocodeLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(promocodeTextField.snp.bottom).offset(30)
            $0.leading.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(Layout.labelWidth)
        }
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
        }
        expirationLabel.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(30)
            $0.leading.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(Layout.labelWidth)
        }
        startExpirationTextField.snp.makeConstraints {
            $0.top.equalTo(expirationLabel.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(Layout.textFieldWidth)
        }
        endExpirationTextField.snp.makeConstraints {
            $0.top.equalTo(expirationLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(Layout.textFieldWidth)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(endExpirationTextField.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.bottom.lessThanOrEqualTo(scrollView.contentLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }

    //MARK: - Actions

    @objc func doneButtonTapped() {
        let text = dateFormatter.string(from: datePicker.date)
        if startExpirationTextField.isEditing {
            startExpirationTextField.text = text
        } else if endExpirationTextField.isEditing {
            endExpirationTextField.text = text
        }
        view.endEditing(true)
    }

    @objc private func createButtonTapped() {
        presenter.createPromocode()
    }

    @objc private func amountTextFieldValueChanged() {
        presenter.amountTextFieldChanged(amountTextField.text)
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

    func setPromocodeState(_ isError: Bool) {
        promocodeLabel.textColor = isError ? .red : .systemGray
    }

    func updateCreateButtonState(_ isValid: Bool) {
        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }

    func updateView(with viewModel: AddPromocodeViewModel) {
        promocodeTextField.text = viewModel.promocode
        amountTextField.text = viewModel.amount
        startExpirationTextField.text = viewModel.startDate
        endExpirationTextField.text = viewModel.endDate
        title = viewModel.title
        createButton.setTitle(viewModel.buttonTitle, for: .normal)
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

//MARK: - UITextFieldDelegate

extension AddPromocodesViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text
        if textField === startExpirationTextField {
            presenter.startExpirationTextFieldChanged(text)
        } else if textField === endExpirationTextField {
            presenter.endExpirationTextFieldChanged(text)
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField === startExpirationTextField {
            presenter.startExpirationTextFieldChanged(nil)
        } else if textField === endExpirationTextField {
            presenter.endExpirationTextFieldChanged(nil)
        }
        view.endEditing(true)
//        textField.resignFirstResponder()
        return true
    }

}

