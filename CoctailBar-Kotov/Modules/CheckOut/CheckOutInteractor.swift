//
//  CheckOutInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.10.2022.
//

import Foundation

final class CheckOutInteractor {

    let orderStorageService = OrderStorageService.shared

    var order = Order()

    let totalPrice: String

    init(totalPrice: String) {
        self.totalPrice = totalPrice
    }

    var isValid: Bool {
        order.userName != nil && order.userName?.count ?? 0 >= 4 && order.userAdress != nil
    }

}
