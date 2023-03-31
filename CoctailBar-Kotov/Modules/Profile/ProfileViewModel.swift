//
//  ProfileViewModel.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 01.08.2022.
//

import UIKit

struct ProfileViewModel {

    var userName: String
    var points: Int
    var avatarURLString: String?

    var section: [ProfileSectionModel]

    init(userName: String,
         points: Int,
         avatarURLString: String?) {
        self.userName = userName
        self.points = points
        self.avatarURLString = avatarURLString

        section = [
            .init(
                title: "",
                items: [
                    .init(cellType: .favorites),
                    .init(cellType: .promocodes),
                    .init(cellType: .order),
                    .init(cellType: .edit)
                ]
            )
        ]
    }

}

struct ProfileSectionModel {

    let title: String
    let items: [ProfileCellModel]
    
}

struct ProfileCellModel {

    enum CellType {
        case favorites
        case promocodes
        case order
        case edit

        var title: String {
            switch self {
            case .favorites:
                return "Favorites"
            case .promocodes:
                return "Promocodes"
            case .order:
                return "Order"
            case .edit:
                return "Edit profile"
            }
        }

        var icon: UIImage {
            switch self {
            case .favorites:
                return UIImage(named: "favoritesIcon") ?? UIImage()
            case .promocodes:
                return UIImage(named: "promoCodesIcon") ?? UIImage()
            case .order:
                return UIImage(named: "emptyCartTabIcon") ?? UIImage()
            case .edit:
                return UIImage(named: "editProfileIcon") ?? UIImage()
            }
        }
    }

    let cellType: CellType

}
