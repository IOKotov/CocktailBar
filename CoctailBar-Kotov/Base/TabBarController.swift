//
//  TabBarController.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 27.07.2022.
//

import UIKit

final class TabBarController: UITabBarController {

    enum TabItem: Int, CaseIterable {
        case main, profile, cart

        var title: String {
            switch self {
            case .main:
                return "Drinks"
            case .profile:
                return "Profile"
            case .cart:
                return "Cart"
            }
        }

        var icon: UIImage? {
            switch self{
            case .main:
                return UIImage(named: "drinkTabIcon")
            case .profile:
                return UIImage(named: "profileTabIcon")
            case .cart:
                return UIImage(named: "emptyCartTabIcon")
            }
        }
    }

    // MARK: - Properties

    private let routers: [BaseRouter]

    // MARK: - LifeCycle

    init(_ routers: [BaseRouter]) {
        self.routers = routers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        tabBar.backgroundImage = nil
        tabBar.shadowImage = nil
        tabBar.barTintColor = .systemGray5
        tabBar.tintColor = .systemBlue
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 15)],
            for: .normal
        )

        viewControllers = getViewControllers()
        configureTabBarAppearance()
    }

    // MARK: - Private Helpers

    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .systemGray5
        tabBarAppearance.shadowColor = .clear

        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func getViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        routers.forEach {
            $0.start()
            guard let navigationController = $0.navigationController else { return }
            viewControllers.append(navigationController)
        }

        return viewControllers
    }
}
