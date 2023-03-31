//
//  CartFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit

class CartFabric {

    class func assembleScreen(router: CartRouter) -> CartViewController {
        let interactor: CartInteractorInterface = CartInteractor()
        let presenter = CartPresenter(router, interactor)
        
        let viewController = CartViewController(presenter: presenter)
        presenter.viewController = viewController
        
        router.delegate = presenter
        
        return viewController
    }

}
