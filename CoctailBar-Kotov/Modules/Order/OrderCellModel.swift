//
//  OrderCellModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import UIKit

struct OrderCellModel {

    let orderNumber: String
    let totalPrice: String
    let userName: String
    let userAdress: String
    let shippingMethod: Order.ShippingMethod

    init(order: Order) {
        orderNumber = order.orderNumber ?? ""
        totalPrice = order.totalPrice ?? ""
        userName = order.userName ?? ""
        userAdress = order.userAdress ?? ""
        shippingMethod = order.shippingMethod ?? Order.ShippingMethod.pickUp
    }

}
