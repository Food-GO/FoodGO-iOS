//
//  CalorieInfoView.swift
//  YoriJori
//
//  Created by 김강현 on 8/23/24.
//

import UIKit
import SnapKit

class CalorieInfoView: UIView {
    
    private var riskCategory = ""
    
    private let riskImageView = UIImageView()
    
    private let foodNameLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let totalCalorieStackView = CalorieInfoStackView(title: "총칼로리", amountText: "146 kcal")
    
    private let proteinStackView = CalorieInfoStackView(title: "단백질", amountText: "6.9g")
    
    private let calciumStackView = CalorieInfoStackView(title: "칼슘", amountText: "24mg")
    
    private let fatStackView = CalorieInfoStackView(title: "지방", amountText: "4.4g")
    
    init(foodName: String, riskCategory: String) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemColor.white.withAlphaComponent(0.8)
        
        self.riskCategory = riskCategory
        self.foodNameLabel.text = foodName
        
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        [riskImageView, foodNameLabel, totalCalorieStackView, proteinStackView, calciumStackView, fatStackView].forEach({self.addSubview($0)})
        
        switch riskCategory {
        case "good":
            riskImageView.image = UIImage(named: "risk_good")
            riskImageView.snp.makeConstraints({
                $0.top.equalToSuperview().offset(12)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(22)
            })
        case "soso":
            riskImageView.image = UIImage(named: "risk_soso")
            riskImageView.snp.makeConstraints({
                $0.top.equalToSuperview().offset(12)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(26)
                $0.height.equalTo(22)
            })
        case "bad":
            riskImageView.image = UIImage(named: "risk_bad")
            riskImageView.snp.makeConstraints({
                $0.top.equalToSuperview().offset(12)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(6)
                $0.height.equalTo(26)
            })
        default:
            return
        }
        
        foodNameLabel.snp.makeConstraints({
            $0.top.equalTo(self.riskImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        })
        
        totalCalorieStackView.snp.makeConstraints({
            $0.top.equalTo(self.foodNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(17)
        })
        
        proteinStackView.snp.makeConstraints({
            $0.top.equalTo(self.totalCalorieStackView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(17)
        })
        
        calciumStackView.snp.makeConstraints({
            $0.top.equalTo(self.proteinStackView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(17)
        })
        
        fatStackView.snp.makeConstraints({
            $0.top.equalTo(self.calciumStackView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(17)
        })
    }
    
}
