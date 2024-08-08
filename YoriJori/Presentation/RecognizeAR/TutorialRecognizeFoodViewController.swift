//
//  TutorialRecognizeFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TutorialRecognizeFoodViewController: UIViewController {
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
    }
    
    private let tutorialLabel = UILabel().then {
        $0.text = "카메라가 식재료를\n향하게 하세요"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = DesignSystemFont.medium20
        $0.textColor = DesignSystemColor.white
    }
    
    private let tutorialImage = UIImageView().then {
        $0.image = UIImage(named: "tutorial_food")
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        [closeButton, tutorialLabel, tutorialImage].forEach({self.view.addSubview($0)})
        
        self.closeButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(28)
        })
        
        self.tutorialLabel.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(94)
            $0.centerX.equalToSuperview()
        })
        
        self.tutorialImage.snp.makeConstraints({
            $0.top.equalTo(self.tutorialLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(107)
            $0.height.equalTo(218)
        })
        
    }
    
    private func bindButtons() {
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

