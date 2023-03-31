//
//  FiltersPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.07.2022.
//

import Foundation

final class FiltersPresenter {
    
    private let router: FiltersRouter
    private let interactor: FiltersInteractor

    weak var viewController: FiltersViewController?

    init(_ router: FiltersRouter, _ interactor: FiltersInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension FiltersPresenter {

    func applyFilterButtonAction() {
        router.applySelectedCategories(interactor.selectedCategories)
    }

    func updateSelectedCategories(_ categories: [String]) {
        interactor.selectedCategories = categories
    }

}
