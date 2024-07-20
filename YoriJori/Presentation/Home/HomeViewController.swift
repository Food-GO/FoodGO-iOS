//
//  HomeViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue.withAlphaComponent(0.5)

    }

}
