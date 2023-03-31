//
//  OrderFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import UIKit

class OrderFabric {

    class func assembleScreen(router: OrderRouter) -> OrderViewController {
        let interactor = OrderInteractor()
        let presenter = OrderPresenter(router, interactor)
        let viewController = OrderViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
