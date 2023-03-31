//
//  MapFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.10.2022.
//

import Foundation

class MapFabric {

    class func assembleScreen(router: MapRouter) -> MapViewController {
        let interactor = MapInteractor()
        let presenter = MapPresenter(router, interactor)
        let viewController = MapViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}

