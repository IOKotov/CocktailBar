//
//  FavoritesViewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 04.08.2022.
//

import UIKit

struct FavoritesViewModel {

    var sections: [FavoritesSectionModel]

    init(drinks: [Drink]) {
        let sectionNames = drinks.map { $0.category ?? "Default Drinks" }.uniqued()

        sections = sectionNames.map { title in
            return FavoritesSectionModel(
                title: title,
                items: drinks.filter({
                    $0.category == title
                }).map({
                    FavoritesCellModel(id: $0.id, title: $0.name, imageURLString: $0.imageURL)
                })
            )
        }
    }

}

struct FavoritesSectionModel {

    let title: String
    let items: [FavoritesCellModel]

}

struct FavoritesCellModel {

    let id: String
    let title: String
    let imageURLString: String

}
