//
//  RegistLastViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit
import Then
import SnapKit

protocol LastRegistViewControllerDelegate {
    func didCompleteLastStep()
}

class LastRegistViewController: UIViewController {
    
    var delegate: LastRegistViewControllerDelegate?
    
    private lazy var testButton = UIButton().then {
        $0.backgroundColor = .blue.withAlphaComponent(0.5)
        $0.setTitle("4", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(testButton)
        testButton.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    

    @objc private func nextButtonTapped() {
        self.delegate?.didCompleteLastStep()
    }

}