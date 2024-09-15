//
//  ShareBottomSheetViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ShareBottomSheetViewController: UIViewController {
    
    private let containerView = UIView()
    
    private let selfieImageView = UIImageView().then {
        $0.image = UIImage(named: "selfie")
        $0.layer.cornerRadius = 7.5
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "에너지 운동가"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.semibold15
    }
    
    private let tasteLabel = UILabel().then {
        $0.text = "요리조리 취향테스트"
        $0.textColor = DesignSystemColor.gray600
        $0.font = DesignSystemFont.semibold15
    }
    
    private let friendButton1 = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: UIColor(hex: "#545456").withAlphaComponent(0.34), selectedBorderColor: DesignSystemColor.yorijoriGreen).then {
        $0.text = "이소정"
        $0.setImage(UIImage(named: "friend2"), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    private let friendButton2 = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: UIColor(hex: "#545456").withAlphaComponent(0.34), selectedBorderColor: DesignSystemColor.yorijoriGreen).then {
        $0.text = "안정후"
        $0.setImage(UIImage(named: "friend2"), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    private let friendButton3 = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: UIColor(hex: "#545456").withAlphaComponent(0.34), selectedBorderColor: DesignSystemColor.yorijoriGreen).then {
        $0.text = "한승연"
        $0.setImage(UIImage(named: "friend3"), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    private let friendButton4 = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900, borderColor: UIColor(hex: "#545456").withAlphaComponent(0.34), selectedBorderColor: DesignSystemColor.yorijoriGreen).then {
        $0.text = "김지훈"
        $0.setImage(UIImage(named: "friend4"), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    private let shareButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "공유하기"
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
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
        containerView.backgroundColor = DesignSystemColor.gray150
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [selfieImageView, closeButton, typeLabel, tasteLabel, friendButton1, friendButton2, friendButton3, friendButton4, shareButton].forEach({self.containerView.addSubview($0)})
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(525)
        }
        
        selfieImageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(60)
        })
        
        closeButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(30)
        })
        
        typeLabel.snp.makeConstraints({
            $0.top.equalTo(self.selfieImageView.snp.top).offset(11)
            $0.leading.equalTo(self.selfieImageView.snp.trailing).offset(16)
        })
        
        tasteLabel.snp.makeConstraints({
            $0.top.equalTo(self.typeLabel.snp.bottom)
            $0.leading.equalTo(self.selfieImageView.snp.trailing).offset(16)
        })
        
        friendButton1.snp.makeConstraints({
            $0.top.equalTo(self.selfieImageView.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(68)
        })
        
        friendButton2.snp.makeConstraints({
            $0.top.equalTo(self.friendButton1.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(68)
        })
        
        friendButton3.snp.makeConstraints({
            $0.top.equalTo(self.friendButton2.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(68)
        })
        
        friendButton4.snp.makeConstraints({
            $0.top.equalTo(self.friendButton3.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(68)
        })
        
        shareButton.snp.makeConstraints({
            $0.top.equalTo(self.friendButton4.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    private func bindButtons() {
        friendButton1.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.friendButton1.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        friendButton2.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.friendButton2.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        friendButton3.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.friendButton3.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        friendButton4.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.friendButton4.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .map { "home" }
            .bind(to: optionSelected)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
