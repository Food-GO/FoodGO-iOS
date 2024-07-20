//
//  MyProfileCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class MyProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let myProfileVC = MyProfileViewController()
        myProfileVC.coordinator = self
        navigationController.setViewControllers([myProfileVC], animated: false)
    }
    
}
