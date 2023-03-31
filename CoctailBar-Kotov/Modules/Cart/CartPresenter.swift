//
//  CartPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import Foundation

final class CartPresenter {

    private let router: CartRouter
    private let interactor: CartInteractorInterface

    weak var viewController: CartViewController?
    
    private var drinks: [Drink] = []
    private var promocode: Promocode?
    private var totalPrice: String?

    init(_ router: CartRouter, _ interactor: CartInteractorInterface) {
        self.router = router
        self.interactor = interactor

        CartStorageService.shared.subscribe(self)
    }

    deinit {
        CartStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension CartPresenter {

    func loadData() {
        defer { viewController?.hideLoader() }
        viewController?.showLoader()

        interactor.getCartWith(currentDrinks: drinks) { [weak self] drinks in
            guard let self = self else { return }
            self.drinks = drinks.sorted(by: { $1.id > $0.id })
            self.updateViewModel()
        }
    }

    func promcodeTextFieldChanged(_ text: String) {
        defer { updateViewModel() }
        guard !text.isEmpty else {
            promocode = nil
            return
        }
        guard !text.isEmpty else { return }
        promocode = interactor.promocodeStorageService.getPromocodes().first(where: { $0.title == text })
        if promocode == nil {
            router.enteredInvalidPromocode()
        }
    }

    func drinkCountChanged(count: Int, id: String) {
        if count == 0 {
            router.openDrinkRemovingAlert(id: id)
        } else {
            interactor.cartStorageService.saveDrinkToCart(id, count: count)
            updateViewModel()
        }
    }

    func goToSelectDrinks() {
        router.openDrinksModule()
    }

    func goToCheckOut() {
        router.openCheckOutModule(totalPrice: totalPrice ?? "")
    }

}

//MARK: - Private Helpers

extension CartPresenter {

    private func updateViewModel() {
        let viewModel = CartViewModel(
            drinks: drinks,
            promocode: promocode,
            drinksCount: interactor.cartStorageService.getCartDrinks()
        )
        self.totalPrice = viewModel.totalPrice
        viewController?.updateViewModel(viewModel: viewModel)
    }

}

//MARK: - CartRouterDelegate

extension CartPresenter: CartRouterDelegate, CartSubscriber {

    func removeDrinkFromCart(id: String) {
        drinks.removeAll(where: { $0.id == id })
        interactor.cartStorageService.removeDrinkFromCart(id)
        updateViewModel()
    }

    func operationCompleted(_ id: String) {
        guard drinks.contains(where: { $0.id == id }) else {
            loadData()
            return
        }
        updateViewModel()
    }

}
