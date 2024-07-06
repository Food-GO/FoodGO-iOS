//
//  AppCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var isFirstLaunched: Bool = UserDefaultsManager.shared.isFirstLaunched
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        if isFirstLaunched {
            self.showOnboardingViewController()
        } else if self.isLoggedIn {
            self.showMainViewController()
        } else {
            self.showLoginViewController()
        }
        
    }
    
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showOnboardingViewController() {
        let coordinator = OnboardingCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
}

// MARK: - 로그인
extension AppCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator}
        self.showMainViewController()
    }
}

// MARK: - 온보딩
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func moveTonext(_ coorDinator: OnboardingCoordinator) {
//        UserDefaultsManager.shared.isFirstLaunched = false
        self.childCoordinators = self.childCoordinators.filter { $0 !== coorDinator}
        self.showLoginViewController()
    }
}

// MARK: - 메인
extension AppCoordinator: MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
}

