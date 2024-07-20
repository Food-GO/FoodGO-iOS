//
//  CommunityViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class CommunityViewController: UIViewController {
    
    weak var coordinator: CommunityCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray.withAlphaComponent(0.5)
    }

}
