//
//  PromocodesStorageService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 07.09.2022.
//

import Foundation

@objc protocol PromocodesSubscriber {
    func operationCompleted()
}

final class PromocodesStorageService {

    static let shared = PromocodesStorageService()

    private var subscribers = NSHashTable<PromocodesSubscriber>.weakObjects()

    func subscribe(_ subscriber: PromocodesSubscriber) {
        subscribers.add(subscriber)
    }

    func unsubcribe(_ subscriber: PromocodesSubscriber) {
        subscribers.remove(subscriber)
    }

    func getPromocodes() -> [Promocode] {
        guard let promocodes = Session.shared.getPromocodes() else { return [] }
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode([Promocode].self, from: promocodes) else { return [] }
        return decoded
    }

    private func addPromocodes(_ promocode: Promocode) {
        var promocodes = getPromocodes()
        promocodes.append(promocode)
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(promocodes)
        Session.shared.savePromocodes(encoded)

        notifySubscribersOperationCompleted()
    }

    func removePromocode(_ promocode: Promocode) {
        var promocodes = getPromocodes()
        promocodes.removeAll { $0.id == promocode.id }
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(promocodes)

        Session.shared.savePromocodes(encoded)
    }

    func changePromocode(_ promocode: Promocode) {
        let promocodes = getPromocodes()
        if promocodes.contains(where: { $0.id == promocode.id }) {
            removePromocode(promocode)
        }
        addPromocodes(promocode)
    }

    private func notifySubscribersOperationCompleted() {
        for subscriber in subscribers.allObjects {
            subscriber.operationCompleted()
        }
    }

}
