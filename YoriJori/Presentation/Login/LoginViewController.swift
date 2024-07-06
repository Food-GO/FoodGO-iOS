//
//  LoginViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol LoginViewControllerDelegate {
    func login()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .purple.withAlphaComponent(0.5)
    }
    

    @objc private func loginButtonDidTap() {
        self.delegate?.login()
    }

}
