//
//  MainCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var delegate: MainCoordinatorDelegate?
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let recommendCoordinator = RecommendFoodCoordinator(navigationController: UINavigationController())
        childCoordinators.append(recommendCoordinator)
        recommendCoordinator.start()
        
        tabBarController.viewControllers = [recommendCoordinator.navigationController]
    }
    
    func logout() {
        self.delegate?.didLoggedOut(self)
    }
    
}
