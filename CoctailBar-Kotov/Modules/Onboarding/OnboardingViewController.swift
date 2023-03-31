//
//  OnboardingViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import UIKit
import SnapKit
import Nuke

final class OnboardingViewController: UIViewController {

    private let presenter: OnboardingPresenter
    private let item: Item

    //MARK: - UI Elements

    private lazy var onboardingImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    //MARK: - Life Cycle

    init(item: Item, presenter: OnboardingPresenter) {
        self.item = item
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        configure()
    }

    //MARK: - Layout

    private func setupSubviews() {
        view.addSubviews(onboardingImage, signInButton, skipButton)
        configureConstraints()
    }

    private func configureConstraints() {
        onboardingImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        skipButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.trailing.leading.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
        signInButton.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
    }

    //MARK: - Actions

    @objc private func signInButtonTapped() {
        presenter.enterAuthorization()
    }

    @objc private func skipButtonTapped() {
        presenter.enterMainModule()
    }
    
    //MARK: - Helpers

    func setButtons() {
        signInButton.isHidden = Session.shared.isUserAutorized()
        skipButton.isHidden = false
    }

    //MARK: - Private helpers

    private func configure() {
        guard let url = URL(string: item.finalImage?.url ?? "") else { return }
        Nuke.loadImage(with: url, into: onboardingImage)
    }

}
