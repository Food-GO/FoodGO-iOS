//
//  CalorieCheckWithTextView.swift
//  YoriJori
//
//  Created by 김강현 on 8/22/24.
//

import UIKit
import SnapKit

class CalorieCheckWithTextView: UIView {
    
    private var riskCategory = ""
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    private let foodNameLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let riskImageView = UIImageView()

    
    init(text: String, risk: String) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemColor.white.withAlphaComponent(0.8)
        
        self.foodNameLabel.text = text
        self.riskCategory = risk
        
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        self.addSubview(stackView)
        [foodNameLabel, riskImageView].forEach({self.stackView.addArrangedSubview($0)})
        
        stackView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-12)
        })
        
        switch riskCategory {
        case "good":
            riskImageView.image = UIImage(named: "risk_good")
            riskImageView.snp.makeConstraints({
                $0.width.height.equalTo(22)
            })
        case "soso":
            riskImageView.image = UIImage(named: "risk_soso")
            riskImageView.snp.makeConstraints({
                $0.width.equalTo(26)
                $0.height.equalTo(22)
            })
        case "bad":
            riskImageView.image = UIImage(named: "risk_bad")
            riskImageView.snp.makeConstraints({
                $0.width.equalTo(6)
                $0.height.equalTo(26)
            })
        default:
            return
        }
    }
    
}
