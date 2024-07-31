//
//  RegisterFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/26/24.
//

import UIKit
import SnapKit

class RegisterFoodViewController: UIViewController {
    
    private let foodNotExistLabel = UILabel().then {
        $0.text = "아직 등록된 식재료가 없어요"
        $0.font = DesignSystemFont.regular14
        $0.textColor = DesignSystemColor.gray600
    }
    
    private let addFoodButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료 추가하기 +"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        self.tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
        setUI()
    }
    
    private func setupNavigationBar() {
        self.title = "내 식재료"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
        let editButton = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = DesignSystemColor.gray600
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func setUI() {
        [foodNotExistLabel, addFoodButton].forEach({self.view.addSubview($0)})
        
        foodNotExistLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        addFoodButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        
    }
    
}
