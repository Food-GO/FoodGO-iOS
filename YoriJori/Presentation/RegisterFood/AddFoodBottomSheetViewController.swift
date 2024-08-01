//
//  AddFoodBottomSheetViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddFoodBottomSheetViewController: UIViewController {
    
    private let containerView = UIView()
    private let recognizeButton = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray150).then {
        $0.text = "식재료 인식"
    }
    private let manualInputButton = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray150).then {
        $0.text = "직접 작성하기"
    }
    
    let optionSelected = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.backgroundColor = DesignSystemColor.white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        containerView.addSubview(recognizeButton)
        containerView.addSubview(manualInputButton)
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
        
        recognizeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(50)
        }
        
        manualInputButton.snp.makeConstraints { make in
            make.top.equalTo(recognizeButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(50)
        }
    }
    
    private func bindButtons() {
        recognizeButton.rx.tap
            .map { "recognize" }
            .bind(to: optionSelected)
            .disposed(by: disposeBag)
        
        manualInputButton.rx.tap
            .map { "manual" }
            .bind(to: optionSelected)
            .disposed(by: disposeBag)
    }
}
