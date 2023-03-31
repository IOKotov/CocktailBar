//
//  CheckOutFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.10.2022.
//

import UIKit

class CheckOutFabric {

    class func assembleScreen(router: CheckOutRouter, totalPrice: String) -> CheckOutViewController {
        let interactor = CheckOutInteractor(totalPrice: totalPrice)
        let presenter = CheckOutPresenter(router, interactor)
        
        let viewController = CheckOutViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
