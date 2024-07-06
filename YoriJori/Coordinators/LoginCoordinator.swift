//
//  LoginCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator, LoginViewControllerDelegate {
    var childCoordinators: [Coordinator] = []
    private var navigationCotroller: UINavigationController!
    var delegate: LoginCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationCotroller = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.delegate = self
        
        self.navigationCotroller.viewControllers = [viewController]
    }
    
    func login() {
        self.delegate?.didLoggedIn(self)
    }
}
