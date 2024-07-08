//
//  RegisterCoordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit

protocol RegisterCoordinatorDelegate {
    func didCompleteRegistation()
}


class RegisterCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    var delegate: RegisterCoordinatorDelegate?
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirstRegistPage()
    }
    
    private func showFirstRegistPage() {
        let firstStepVC = FirstRegistViewController()
        firstStepVC.delegate = self
        self.navigationController.pushViewController(firstStepVC, animated: true)
    }
    
    private func showSecondRegistPage() {
        let secondStepVC = SecondRegistViewController()
        secondStepVC.delegate = self
        self.navigationController.pushViewController(secondStepVC, animated: true)
    }
    
    private func showThirdRegistPage() {
        let thirdStepVC = ThirdRegistViewController()
        thirdStepVC.delegate = self
        self.navigationController.pushViewController(thirdStepVC, animated: true)
    }
    
    private func showLastRegistPage() {
        let fourthStepVC = LastRegistViewController()
        fourthStepVC.delegate = self
        self.navigationController.pushViewController(fourthStepVC, animated: true)
    }
    
}

extension RegisterCoordinator: FirstRegistViewControllerDelegate {
    func didCompleteFirstStep() {
        self.showSecondRegistPage()
    }
}

extension RegisterCoordinator: SecondRegistViewControllerDelegate {
    func didCompleteSecondStep() {
        self.showThirdRegistPage()
    }
}

extension RegisterCoordinator: ThirdRegistViewControllerDelegate {
    func didCompleteThirdStep() {
        self.showLastRegistPage()
    }
}

extension RegisterCoordinator: LastRegistViewControllerDelegate {
    func didCompleteLastStep() {
        self.delegate?.didCompleteRegistation()
    }
}
