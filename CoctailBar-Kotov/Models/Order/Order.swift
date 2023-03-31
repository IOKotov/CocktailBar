//
//  Order.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 07.11.2022.
//

import Foundation

struct Order: Codable {

    var orderNumber: String?
    var userName: String?
    var userAdress: String?
    var totalPrice: String?
    var shippingMethod: ShippingMethod?

    enum ShippingMethod: Codable {
        case delivery
        case pickUp
    }

}
