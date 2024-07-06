//
//  MainViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

protocol MainViewControllerDelegate {
    func logout()
}

class MainViewController: UIViewController {
    
    var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    }
    
    @objc private func logoutButtonTapped() {
        self.delegate?.logout()
    }

}
