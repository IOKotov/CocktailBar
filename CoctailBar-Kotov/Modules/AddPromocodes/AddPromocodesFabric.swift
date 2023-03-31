//
//  AddPromocodesFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.09.2022.
//

import UIKit

class AddPromocodesFabric {

    class func assembleScreen(router: AddPromocodesRouter, promocode: Promocode?) -> AddPromocodesViewController {
        let interactor = AddPromocodesInteractor(promocode: promocode)
        let presenter = AddPromocodesPresenter(router, interactor)
        let viewController = AddPromocodesViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
