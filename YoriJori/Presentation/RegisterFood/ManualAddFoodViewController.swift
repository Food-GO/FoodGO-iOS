//
//  ManualAddFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/2/24.
//

import UIKit
import SnapKit

class ManualAddFoodViewController: UIViewController {
    
    private let photoView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
        $0.layer.cornerRadius = 12
    }
    
    private let emptyPhotoImageView = UIImageView().then {
        $0.image = UIImage(named: "empty_photo")
    }
    
    private let photoImageBottomDivider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let foodNameLabel = UILabel().then {
        $0.text = "식재료명"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.title3
    }
    
    private let foodTextField = YorijoriTextField().then {
        $0.placeholder = "식재료 명을 입력해주세요"
    }
    
    private let foodTextFieldBottomDivider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let countLabel = UILabel().then {
        $0.text = "수량"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.title3
    }
    
    private let countView = CounterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        
        setupNavigationBar()
        setUI()
    }
    
    
    private func setupNavigationBar() {
        self.title = "식재료 추가"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    private func setUI() {
        [photoView, photoImageBottomDivider, foodNameLabel, foodTextField, foodTextFieldBottomDivider, countLabel, countView].forEach({self.view.addSubview($0)})
        self.photoView.addSubview(emptyPhotoImageView)
        
        photoView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(260)
        })
        
        emptyPhotoImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        })
        
        photoImageBottomDivider.snp.makeConstraints({
            $0.top.equalTo(self.photoView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        })
        
        foodNameLabel.snp.makeConstraints({
            $0.top.equalTo(self.photoImageBottomDivider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
        })
        
        foodTextField.snp.makeConstraints({
            $0.top.equalTo(self.foodNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(46)
        })
        
        foodTextFieldBottomDivider.snp.makeConstraints({
            $0.top.equalTo(self.foodTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        })
        
        countLabel.snp.makeConstraints({
            $0.top.equalTo(self.foodTextFieldBottomDivider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
        })
        
        countView.snp.makeConstraints({
            $0.top.equalTo(self.countLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(18)
            $0.width.equalTo(248)
            $0.height.equalTo(46)
        })
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    

}
