//
//  PromoCodesPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import Foundation

final class PromoCodesPresenter {

    private let router: PromoCodesRouter
    private let interactor: PromoCodesInteractor

    private var promocodes: [Promocode] = []

    weak var viewController: PromoCodesViewController?

    init(_ router: PromoCodesRouter, _ interactor: PromoCodesInteractor) {
        self.router = router
        self.interactor = interactor

        PromocodesStorageService.shared.subscribe(self)
    }
    
    deinit {
        PromocodesStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension PromoCodesPresenter {

    func loadData() {
        updateViewModel()
    }

    func deletePromocodeAt(_ id: UUID) {
        guard let promocode = promocodes.first(where: { $0.id == id }) else { return }
        interactor.promocodesStorageService.removePromocode(promocode)
    }

    func didSelectAddPromocodes() {
        router.openAddPromocodesModule()
    }

    func didSelectChangePromocode(_ id: UUID) {
        guard let promocode = promocodes.first(where: { $0.id == id }) else { return }
        router.openAddPromocodesModule(promocode)
    }

}

//MARK: - Private Helpers

extension PromoCodesPresenter {

    private func updateViewModel() {
        promocodes = interactor.promocodesStorageService.getPromocodes()
        let cellModels = promocodes.map {
            PromocodeCellModel(promocode: $0)
        }.sorted(by: { $0.discount > $1.discount })
        viewController?.updateViewModel(cellModels: cellModels)
    }

}

//MARK: - FavouritesSubscriber

extension PromoCodesPresenter: PromocodesSubscriber {
    
    func operationCompleted() {
        loadData()
    }

}
