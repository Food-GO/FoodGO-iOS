//
//  RecommendCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class RecommendFoodCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let recommendVC = RecommendFoodViewController()
        recommendVC.coordinator = self
        navigationController.setViewControllers([recommendVC], animated: false)
    }
    
}
