//
//  CommunityCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class CommunityCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let communityVC = CommunityViewController()
        communityVC.coordinator = self
        navigationController.setViewControllers([communityVC], animated: false)
    }
    
}
