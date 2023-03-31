//
//  OrderStorageService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 21.11.2022.
//

import Foundation

@objc protocol OrderSubscriber {
    func operationCompleted()
}

final class OrderStorageService {

    static let shared = OrderStorageService()

    private var subscribers = NSHashTable<OrderSubscriber>.weakObjects()

    func subscribe(_ subscriber: OrderSubscriber) {
        subscribers.add(subscriber)
    }

    func unsubcribe(_ subscriber: OrderSubscriber) {
        subscribers.remove(subscriber)
    }

    func getOrders() -> [Order] {
        guard let orders = Session.shared.getOrder() else { return [] }
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode([Order].self, from: orders) else { return [] }
        return decoded
    }

    func addOrder(_ order: Order) {
        var orders = getOrders()
        orders.append(order)
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(orders)
        Session.shared.saveOrder(encoded)

        notifySubscribersOperationCompleted()
    }

    func removeOrder(_ order: Order) {
        var orders = getOrders()
        orders.removeAll { $0.orderNumber == order.orderNumber }
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(orders)
        Session.shared.saveOrder(encoded)

    }

    private func notifySubscribersOperationCompleted() {
        for subscriber in subscribers.allObjects {
            subscriber.operationCompleted()
        }
    }

}
