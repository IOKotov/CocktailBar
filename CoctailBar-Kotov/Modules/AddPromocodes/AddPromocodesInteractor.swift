//
//  AddPromocodesInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.09.2022.
//

import Foundation

final class AddPromocodesInteractor {

    var promocode: Promocode

    let promocodesStorageService = PromocodesStorageService.shared

    init(promocode: Promocode?) {
        self.promocode = promocode ?? Promocode()
    }

}
