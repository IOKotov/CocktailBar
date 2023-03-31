//
//  PromoCodesFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

class PromoCodesFabric {

    class func assembleScreen(router: PromoCodesRouter) -> PromoCodesViewController {
        let interactor = PromoCodesInteractor()
        let presenter = PromoCodesPresenter(router, interactor)
        let viewController = PromoCodesViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
