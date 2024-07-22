//
//  MainViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import SnapKit

class RecommendFoodViewController: UIViewController {
    
    weak var coordinator: RecommendFoodCoordinator?
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = DesignSystemColor.mainColor
    }
    
    private let userTasteLabel = UILabel().then {
        $0.text = "이00님은\n어떤 취향일까요?"
        $0.numberOfLines = 0
        $0.font = DesignSystemFont.semiBold18
        $0.textColor = DesignSystemColor.textColor
        $0.textAlignment = .center
    }
    
    private let foodTasteTestButton = UIButton().then {
        $0.setTitle("테스트 하러가기", for: .normal)
        $0.titleLabel?.font = DesignSystemFont.medium14
        $0.backgroundColor = DesignSystemColor.mainColor
        $0.tintColor = .white
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 4
    }
    
    private let grayView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#E4E4E4")
    }
    
    private let myGradientLabel = UILabel().then {
        $0.text = "내 식재료"
        $0.font = DesignSystemFont.medium18
        $0.textColor = DesignSystemColor.textColor
    }
    
    private let registerView = FoodRegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUI()
    }
    
    private func setUI() {
        [profileImage, userTasteLabel, foodTasteTestButton, grayView, myGradientLabel, registerView].forEach({self.view.addSubview($0)})
        
        profileImage.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(27)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(72)
        })
        profileImage.layer.cornerRadius = 36
        
        userTasteLabel.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        })
        
        foodTasteTestButton.snp.makeConstraints({
            $0.top.equalTo(self.userTasteLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(41)
        })
        
        grayView.snp.makeConstraints({
            $0.top.equalTo(self.foodTasteTestButton.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        myGradientLabel.snp.makeConstraints({
            $0.top.equalTo(self.grayView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        })
        
        registerView.snp.makeConstraints({
            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(190)
        })
    }

}
