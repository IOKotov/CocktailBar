//
//  UINavigationController+Helpers.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 27.07.2022.
//

import UIKit

extension UINavigationController {

    func configureTabBarItem(with tabItem: TabBarController.TabItem) {
        tabBarItem.title = tabItem.title
        tabBarItem.image = tabItem.icon?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = tabItem.icon
        tabBarItem.tag = tabItem.rawValue
    }

}
