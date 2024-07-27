//
//  FoodRegisterView.swift
//  YoriJori
//
//  Created by 김강현 on 7/22/24.
//

import UIKit
import SnapKit
import RxSwift

class FoodRegisterView: UIView {
    
    private let notExistIngredientsLabel = UILabel().then {
        $0.text = "아직 등록된 식재료가 없어요"
        $0.textColor = DesignSystemColor.gray600
        $0.font = DesignSystemFont.subTitle2
    }
    
    let registerButton = YorijoriButton().then {
        $0.text = "식재료 등록하기 +"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor(hex: "#A7A7A7").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [notExistIngredientsLabel, registerButton].forEach({self.addSubview($0)})
        
        notExistIngredientsLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        registerButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        })
    }
    
}
