//
//  ProfileTableViewCell.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell, ClassIdentifiable {

    //MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        view.backgroundColor = .white
        return view
    }()

    private lazy var profileImageView = UIImageView()

    private lazy var arrowImageView = UIImageView()

    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Layout

    private func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubviews(
            titleLabel,
            profileImageView,
            arrowImageView
        )
        configureConstraints()
    }

    private func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(containerView).inset(20)
            $0.leading.equalTo(containerView).offset(10)
            $0.width.equalTo(profileImageView.snp.height)
        }
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(containerView).inset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        arrowImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(containerView).inset(25)
            $0.trailing.equalTo(containerView).inset(20)
            $0.width.equalTo(profileImageView.snp.height)
        }
    }

    //MARK: - Configuration

    func configure(with title: String, image: UIImage) {
        titleLabel.text = title
        profileImageView.image = image
        arrowImageView.image = UIImage(named: "arrowIcon")
    }

}
