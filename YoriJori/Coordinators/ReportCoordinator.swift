//
//  ReportCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class ReportCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reportVC = ReportViewController()
        reportVC.coordinator = self
        navigationController.setViewControllers([reportVC], animated: false)
    }
    
}

