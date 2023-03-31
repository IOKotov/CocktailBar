//
//  DeliveryFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 26.10.2022.
//

import Foundation

class DeliveryFabric {

    class func assembleScreen(router: DeliveryRouter, delegate: DeliveryPresenterDelegate) -> DeliveryViewController {
        let interactor = DeliveryInteractor()
        let presenter = DeliveryPresenter(router, interactor, delegate: delegate)
        let viewController = DeliveryViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
