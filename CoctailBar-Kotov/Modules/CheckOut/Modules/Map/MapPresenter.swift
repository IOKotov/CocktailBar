//
//  MapPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.10.2022.
//

import Foundation
import YandexMapsMobile

final class MapPresenter: NSObject {

    private let router: MapRouter
    private let interactor: MapInteractor
    let shops = [
        Shop(name: "First shop", point: YMKPoint(latitude: 54.986289, longitude: 73.363163)),
        Shop(name: "Second shop", point: YMKPoint(latitude: 55.009182, longitude: 73.341083)),
        Shop(name: "Third shop", point: YMKPoint(latitude: 54.993525, longitude: 73.356262))
    ]

    weak var viewController: MapViewController?
    weak var childViewController: MapChildViewController?

    init(_ router: MapRouter, _ interactor: MapInteractor) {
        self.router = router
        self.interactor = interactor
    }

}

//MARK: - Helpers

extension MapPresenter {

    func getShops() -> [Shop] {
        shops
    }

    func updateViews() {
        childViewController?.updateChildView(text: "first shop")
    }
    
    func confirmAdress() {
        
    }

}
