//
//  OnboardingCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol OnboardingCoordinatorDelegate {
    func moveTonext(_ coorDinator: OnboardingCoordinator)
}

class OnboardingCoordinator: Coordinator, OnboardingContainerViewControllerDelegate {
    var childCoordinators: [Coordinator] = []
    private var navigationViewController: UINavigationController!
    var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationViewController = navigationController
    }
    
    func start() {
        let viewController = OnboardingContainerViewController()
        viewController.delegate = self
        self.navigationViewController.viewControllers = [viewController]
    }
    
    func moveToNext() {
        self.delegate?.moveTonext(self)
    }
    
    
}