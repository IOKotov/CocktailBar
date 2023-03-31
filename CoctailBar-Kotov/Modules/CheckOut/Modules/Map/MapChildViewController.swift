//
//  MapChildViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 11.11.2022.
//

import UIKit
import SnapKit

final class MapChildViewController: UIViewController {

    private let presenter: MapPresenter

    //MARK: - UI Elements
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var adressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Select this bar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(adressButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    //MARK: - Life Cycle

    init(presenter: MapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        presenter.updateViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.updateViews()
    }

    //MARK: - Layout

    private func setupSubviews() {

        view.addSubview(contentView)
        contentView.addSubviews(adressLabel, adressButton)
        configureConstraints()
    }

    private func configureConstraints() {
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(400)
        }
        adressLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.trailing.equalTo(20)
        }
        adressButton.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    //MARK: - Actions

    @objc private func adressButtonTapped() {
        presenter.confirmAdress()
    }

    //MARK: - Helpers

    func updateChildView(text: String) {
        adressLabel.text = text
    }


}
