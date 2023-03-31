//
//  EditProfileRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

protocol EditProfileRouterDelegate: AnyObject {
    func applyChangeUserName(_ userName: String)
}

final class EditProfileRouter: BaseRouter {
    
    private var userName: String
    
    weak var delegate: EditProfileRouterDelegate?

    init(userName: String,
         navigationController: UINavigationController) {
        self.userName = userName
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = EditProfileFabric.assembleScreen(router: self, userName: userName)
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Routing Methods

extension EditProfileRouter {

    func applyNewUserName(_ userName: String) {
        guard let navigationController = navigationController, let delegate = delegate else { return }
        delegate.applyChangeUserName(userName)
        navigationController.popViewController(animated: true)
    }

}
