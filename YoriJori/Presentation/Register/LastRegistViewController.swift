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
    
    private let progressBar = UIView().then {
        $0.backgroundColor = .red.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 2
    }
    
    private lazy var nextButton = UIButton().then {
        $0.backgroundColor = .blue.withAlphaComponent(0.5)
        $0.setTitle("시작하기", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUI()
        
        
        
    }
    
    private func setUI() {
        [progressBar, nextButton].forEach({self.view.addSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-50)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
        })
    }
    

    @objc private func nextButtonTapped() {
        self.delegate?.didCompleteLastStep()
    }

}
