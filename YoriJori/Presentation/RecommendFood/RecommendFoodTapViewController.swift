//
//  MainViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import SnapKit
import RxSwift

class RecommendFoodTapViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let topBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemColor.yorijoriPink
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "energe_character")
    }
    
    private let userTasteLabel = UILabel().then {
        $0.text = "이00님의 음식 취향은\n어떤 취향 일까요?"
        $0.numberOfLines = 0
        $0.font = DesignSystemFont.semibold18
        $0.textColor = DesignSystemColor.white
        $0.textAlignment = .center
    }
    
    private let foodTasteTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.yorijoriPink).then {
        $0.text = "테스트 하러가기"
    }
    
    private let grayView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let myGradientLabel = UILabel().then {
        $0.text = "내 식재료"
        $0.font = DesignSystemFont.subTitle2
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let registerView = FoodRegisterView()
    
    private let foodRecommendButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "음식 추천받기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.gray150
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUI() {
        [topBackgroundView, grayView, myGradientLabel, registerView, foodRecommendButton].forEach({self.view.addSubview($0)})
        [profileImage, userTasteLabel, foodTasteTestButton].forEach({self.topBackgroundView.addSubview($0)})
        
        topBackgroundView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(411)
        })
        
        profileImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(64)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(209)
            $0.height.equalTo(186)
        })
        
        userTasteLabel.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        })
        
        foodTasteTestButton.snp.makeConstraints({
            $0.top.equalTo(self.userTasteLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(42)
        })
        
        grayView.snp.makeConstraints({
            $0.top.equalTo(self.topBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        myGradientLabel.snp.makeConstraints({
            $0.top.equalTo(self.grayView.snp.top).offset(28)
            $0.leading.equalToSuperview().offset(16)
        })
        
        registerView.snp.makeConstraints({
            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(190)
        })
        
        foodRecommendButton.snp.makeConstraints({
            $0.top.equalTo(self.registerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        })
    }
    
    private func bind() {
        foodTasteTestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.moveToTasteTest()
            })
            .disposed(by: disposeBag)
        
        registerView.isUserInteractionEnabled = true
        registerView.registerButton.rx.tap
            .subscribe (onNext: { [weak self] in
                self?.moveToFoodRegister()
            })
            .disposed(by: disposeBag)
        
        foodRecommendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.moveToFoodRecommend()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToTasteTest() {
        let vc = FirstTasteTestViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToFoodRegister() {
        let vc = RegisterFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToFoodRecommend() {
        let vc = RecommendFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
