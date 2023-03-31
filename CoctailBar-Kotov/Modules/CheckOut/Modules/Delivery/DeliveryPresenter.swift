//
//  DeliveryPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 26.10.2022.
//

import Foundation

protocol DeliveryPresenterDelegate: AnyObject {
    func applyChangeUserAdress(_ adress: String, method: Order.ShippingMethod)
}

final class DeliveryPresenter: NSObject {

    private let router: DeliveryRouter
    private let interactor: DeliveryInteractor
    private var throttler: Throttler?

    weak var viewController: DeliveryViewController?
    
    weak var delegate: DeliveryPresenterDelegate?

    init(_ router: DeliveryRouter, _ interactor: DeliveryInteractor, delegate: DeliveryPresenterDelegate) {
        self.router = router
        self.interactor = interactor
        
        self.delegate = delegate
    }

}

//MARK: - Helpers

extension DeliveryPresenter {

    func adressTextFieldValueChanged(_ text: String) {
        self.throttler?.throttle(query: text) { [weak self] items in
            DispatchQueue.main.async { [weak self] in
                self?.throttler = nil
                self?.interactor.suggestions = items
                self?.updateSuggsessions()
            }
        }
        guard self.throttler != nil else {
            self.throttler = Throttler()
            return
        }
    }

    private func updateSuggsessions() {
        viewController?.updateSuggsessions(with: interactor.suggestions)
    }

    func didSelectSuggsession(_ suggestion: String) {
        viewController?.updateTextFieldText(suggestion: suggestion)
    }

    func confirmButtonTapped(_ text: String, _ method: Order.ShippingMethod) {
        delegate?.applyChangeUserAdress(text, method: method)
        router.applyNewUserAdress()
    }

}
