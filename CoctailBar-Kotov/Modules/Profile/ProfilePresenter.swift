//
//  ProfilePresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

final class ProfilePresenter {

    private let router: ProfileRouter
    private let interactor: ProfileInteractor

    weak var viewController: ProfileViewController?

    init(_ router: ProfileRouter, _ interactor: ProfileInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension ProfilePresenter {

    func viewDidLoad() {
        let viewModel = ProfileViewModel(
            userName: interactor.userName,
            points: 0,
            avatarURLString: nil
        )
        viewController?.updateViewModel(viewModel: viewModel)
    }

    func logOutAction() {
        router.logOut()
    }

    func routingOnScreenProfile(indexPath: IndexPath) {
        guard let items = viewController?.viewModel?.section[indexPath.section].items[indexPath.row] else { return }

        switch items.cellType {
        case .favorites:
            return didSelectFavorites()
        case .promocodes:
            return didSelectPromocodes()
        case .order:
            return didSelectOrder()
        case .edit:
            return didSelectEditProfile()
        }
    }

    func didSelectFavorites() {
        router.openFavoritesModule()
    }

    func didSelectPromocodes() {
        router.openPromocodesModule()
    }
    func didSelectOrder() {
        router.openOrderModule()
    }
    func didSelectEditProfile() {
        router.openEditProfileModule(userName: interactor.userName)
    }

}

//MARK: - ProfileRouterDelegate

extension ProfilePresenter: ProfileRouterDelegate {

    func updateUserData(userName: String) {
        interactor.userName = userName
        let viewModel = ProfileViewModel(
            userName: userName,
            points: 0,
            avatarURLString: nil
        )
        viewController?.updateViewModel(viewModel: viewModel)
    }

}
