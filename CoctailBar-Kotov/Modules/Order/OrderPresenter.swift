//
//  OrderPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import Foundation

final class OrderPresenter {

    private let router: OrderRouter
    private var interactor: OrderInteractor

    private var orders: [Order] = []

    weak var viewController: OrderViewController?

    init(_ router: OrderRouter, _ interactor: OrderInteractor) {
        self.router = router
        self.interactor = interactor

        OrderStorageService.shared.subscribe(self)
    }

    deinit {
        OrderStorageService.shared.unsubcribe(self)
    }

}

//MARK: - Helpers

extension OrderPresenter {

    func loadData() {
        updateViewModel()
    }

    func deleteOrders(_ orderNumber: String) {
        guard let order = orders.first(where: { $0.orderNumber == orderNumber }) else { return }
        interactor.orderStorageService.removeOrder(order)
    }

}

//MARK: - Private Helpers

extension OrderPresenter {

    private func updateViewModel() {
        orders = interactor.orderStorageService.getOrders()
        let cellModels = orders.map {
            OrderCellModel(order: $0)
        }
        viewController?.updateViewModel(cellModels: cellModels)
    }

}

//MARK: - OrderSubscriber

extension OrderPresenter: OrderSubscriber {

    func operationCompleted() {
        loadData()
    }

}
