//
//  CheckOutPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.10.2022.
//

import Foundation

final class CheckOutPresenter {

    private let router: CheckOutRouter
    private let interactor: CheckOutInteractor

    weak var delegate: CartRouterDelegate?

    weak var viewController: CheckOutViewController?

    init(_ router: CheckOutRouter, _ interactor: CheckOutInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension CheckOutPresenter {

    func deliveryButtonTapped() {
        router.openDeliveryModule(delegate: self)
    }

    func pickupButtonTapped() {
        router.openMapModule()
    }

    func successCreateNewOrder() {
        interactor.orderStorageService.addOrder(interactor.order)
        viewController?.successNewOrder()
        interactor.order.userAdress = nil
        router.successCreatedOrder()

    }

    func getTotalSumm() -> String {
        interactor.order.totalPrice = interactor.totalPrice
        return interactor.order.totalPrice ?? ""
    }

    func getShippingAdress() -> String {
        interactor.order.userAdress ?? ""
    }

    func saveUserName(text: String) {
        interactor.order.userName = text
        viewController?.updateButtonState(interactor.isValid)
    }

    func saveOrderNumber(text: String) {
        interactor.order.orderNumber = text
    }

}

//MARK: - DeliveryPresenterDelegate

extension CheckOutPresenter: DeliveryPresenterDelegate {
    
    func applyChangeUserAdress(_ adress: String, method: Order.ShippingMethod) {
        interactor.order.userAdress = adress
        interactor.order.shippingMethod = method
        viewController?.updateTextViews(text: adress, method: method)
        viewController?.updateButtonState(interactor.isValid)
    }

}
