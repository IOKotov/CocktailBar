//
//  FavoritesPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

final class FavoritesPresenter {

    private let router: FavoritesRouter
    private var interactor: FavoritesInteractorInterface

    weak var viewController: FavoritesViewController?

    private var drinks: [Drink] = []

    init(_ router: FavoritesRouter, _ interactor: FavoritesInteractorInterface) {
        self.router = router
        self.interactor = interactor

        FavoritesStorageService.shared.subscribe(self)
    }

    deinit {
        FavoritesStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension FavoritesPresenter {

    func loadData() {
        defer { viewController?.hideLoader() }
        self.viewController?.showLoader()

        self.interactor.getFavoritesWith(currentDrinks: drinks) { [weak self] drinks in
            guard let self = self else { return }
            self.drinks = drinks.sorted(by: { $1.id > $0.id })
            self.updateViewModel()
        }
    }

    func didSelectItem(with id: String) {
        router.openDetailModule(id: id)
    }

    func goToSelectDrinks() {
        router.openDrinksModule()
    }

}

//MARK: - Private Helpers

extension FavoritesPresenter {

    private func updateViewModel() {
        let viewModel = FavoritesViewModel(drinks: drinks)
        viewController?.updateViewModel(viewModel: viewModel)
    }

}

//MARK: - FavouritesSubscriber

extension FavoritesPresenter: FavoritesSubscriber {

    func operationCompletedFor(_ id: String) {
        drinks.removeAll(where: { $0.id == id })
        loadData()
    }

}
