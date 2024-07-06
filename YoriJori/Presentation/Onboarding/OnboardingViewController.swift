//
//  OnboardingViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func moveToNext()
}

class OnboardingViewController: UIViewController {
    
    var delegate: OnboardingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func nextButtonTapped() {
        self.delegate?.moveToNext()
    }

}
