//
//  DrinksPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 07.07.2022.
//

import Foundation

final class DrinksPresenter {
    
    private let router: DrinksRouter
    private let interactor: DrinksInteractor

    weak var viewController: DrinksViewController?

    init(_ router: DrinksRouter, _ interactor: DrinksInteractor) {
        self.router = router
        self.interactor = interactor
        FavoritesStorageService.shared.subscribe(self)
    }
    deinit {
        FavoritesStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension DrinksPresenter {

    func loadView() {
        guard let viewController = viewController else { return }
        DispatchQueue.main.async {
            viewController.showLoader()
        }

        let group = DispatchGroup()

        interactor.drinksService.getCategories { categories in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let categories = categories else { return }
                self.interactor.categories = categories.drinks

                categories.drinks.forEach { category in
                    group.enter()
                    self.interactor.drinksService.getCategoryDrinks(
                        category: category.name
                    ) { categoryDrinks in
                        guard let categoryDrinks = categoryDrinks else { return }
                        self.interactor.categoryDrinks[category.name] = categoryDrinks.drinks
                        group.leave()
                    }
                }

                (0...10).forEach { _ in
                    group.enter()
                    self.interactor.drinksService.getRandomDrinks { categoryDrinks in
                        guard let randomDrink = categoryDrinks?.drinks.first else { return }
                        self.interactor.randomDrinks.insert(randomDrink)
                        group.leave()
                    }
                }

                group.notify(queue: .main) { [weak self] in
                    guard let self = self else {
                        viewController.hideLoader()
                        return
                    }
                    let viewModel = DrinksViewModel(
                        categories: self.interactor.categories,
                        categoryDrinks: self.interactor.categoryDrinks,
                        randomDrinks: Array(self.interactor.randomDrinks),
                        favoriteDrinks: self.interactor.favoriteStorageService.getFavoriteDrinks()
                    )
                    viewController.updateData(viewModel: viewModel)
                    viewController.hideLoader()
                }
            }
        }
    }

    func filterButtonAction() {
        router.openFiltersModule(
            categories: interactor.categories,
            selectedCategories: interactor.selectedCategories
        )
    }

    func didSelectItem(with id: String) {
        router.openDetailModule(id: id)
    }

}

//MARK: - DrinksRouterDelegate

extension DrinksPresenter: DrinksRouterDelegate {
    
    func updateSelectedCategories(_ categories: [String]) {
        interactor.selectedCategories = categories
        let viewModel = DrinksViewModel(
            categories: interactor.categories,
            categoryDrinks: interactor.categoryDrinks,
            randomDrinks: Array(interactor.randomDrinks),
            selectedCategories: categories,
            favoriteDrinks: interactor.favoriteStorageService.getFavoriteDrinks()
        )
        viewController?.updateData(viewModel: viewModel)
    }

}

//MARK: - FavouritesSubscriber

extension DrinksPresenter: FavoritesSubscriber {

    func operationCompletedFor(_ id: String) {
        let categories = interactor.selectedCategories
        let viewModel = DrinksViewModel(
            categories: interactor.categories,
            categoryDrinks: interactor.categoryDrinks,
            randomDrinks: Array(interactor.randomDrinks),
            selectedCategories: categories,
            favoriteDrinks: interactor.favoriteStorageService.getFavoriteDrinks()
        )
        viewController?.updateData(viewModel: viewModel)
    }

}
