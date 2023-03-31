//
//  DrinkDetailPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 13.07.2022.
//

import Foundation

final class DrinkDetailPresenter {

    private let router: DrinkDetailRouter
    private let interactor: DrinkDetailInteractor

    weak var viewController: DrinkDetailViewController?

    init(_ router: DrinkDetailRouter, _ interactor: DrinkDetailInteractor) {
        self.router = router
        self.interactor = interactor

        FavoritesStorageService.shared.subscribe(self)
        CartStorageService.shared.subscribe(self)
    }

    deinit {
        FavoritesStorageService.shared.unsubcribe(self)
        CartStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension DrinkDetailPresenter {

    func loadData() {
        guard let viewController = viewController else { return }
        viewController.showLoader()

        interactor.drinkDetailService.getDrinkDetails(id: interactor.id) { [weak self] categoryDrinks in
            guard let self = self else { return }

            guard let drink = categoryDrinks?.drinks.first else { return }
            self.interactor.drinkDetails = drink
            let viewModel = DrinkDetailViewModel(
                drink: drink,
                favoriteDrinks: self.interactor.favoriteStorageService.getFavoriteDrinks()
            )
            DispatchQueue.main.async {
                viewController.updateData(viewModel: viewModel)
                viewController.hideLoader()
            }
        }
    }

    func didSelectFavoriteDrink(id: String) {
        interactor.favoriteStorageService.favoritesDrinksAction(id)
    }

    func didSelectDrinkToCart(id: String) {
        interactor.cartStorageService.saveDrinkToCart(id)
    }

}

//MARK: - FavouritesSubscriber

extension DrinkDetailPresenter: FavoritesSubscriber {

    func operationCompletedFor(_ id: String) {
        guard let drink = interactor.drinkDetails else { return }
        let viewModel = DrinkDetailViewModel(
            drink: drink,
            favoriteDrinks: interactor.favoriteStorageService.getFavoriteDrinks()
        )
        viewController?.updateData(viewModel: viewModel)
    }

}

//MARK: - CartSubscriber

extension DrinkDetailPresenter: CartSubscriber {

    func operationCompleted(_ id: String) {
        guard let drink = interactor.drinkDetails else { return }
        let viewModel = DrinkDetailViewModel(
            drink: drink,
            favoriteDrinks: interactor.favoriteStorageService.getFavoriteDrinks()
        )
        viewController?.updateData(viewModel: viewModel)
    }

}
