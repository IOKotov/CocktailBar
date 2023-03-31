//
//  ProfileHeaderView.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit
import Nuke

final class ProfileHeaderView: UITableViewHeaderFooterView, ClassIdentifiable {

    private enum Layout {
        static let avatarImageViewSize: CGSize = .init(width: 100, height: 100)
    }

    //MARK: - UI Elements

    private lazy var avatarImageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = Layout.avatarImageViewSize.width / 2
        image.clipsToBounds = true
        return image
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Points"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    //MARK: - Life Cycle

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Layout

    private func setupSubviews() {

        addSubviews(
            avatarImageView,
            nicknameLabel,
            pointsLabel
        )
        configureConstraints()
    }

    private func configureConstraints() {
        avatarImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.size.equalTo(Layout.avatarImageViewSize)
            $0.centerX.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        pointsLabel.snp.makeConstraints() {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - Configuration

    func configure(with userName: String, points: Int, avatarURLString: String?) {
        nicknameLabel.text = userName
        pointsLabel.text = "Points: \(points)"
        avatarImageView.image = UIImage(named: "profileIcon")
    }

}
