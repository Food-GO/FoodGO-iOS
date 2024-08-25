//
//  WeeklyReportView.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit
import SnapKit

class WeeklyReportView: UIView {
    
    private let currentWeekLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
        $0.text = "8월 3주차 리포트"
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private lazy var calorieChangeDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold18
        $0.text = "지난주 보다 총 칼로리가\n85 kcal 늘었어요"
        $0.numberOfLines = 0
        $0.asColor(targetString: "85 kcal", color: DesignSystemColor.yorijoriPink)
    }
    
    private let weeklychangeImageView = UIImageView().then {
        $0.image = UIImage(named: "weeklyReport")
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DesignSystemColor.white
        self.layer.cornerRadius = 12
        self.layer.borderColor = DesignSystemColor.gray150.cgColor
        self.layer.borderWidth = 1
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [currentWeekLabel, divider, calorieChangeDescLabel, weeklychangeImageView].forEach({self.addSubview($0)})
        
        currentWeekLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
        })
        
        divider.snp.makeConstraints({
            $0.top.equalTo(self.currentWeekLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(1)
        })
        
        calorieChangeDescLabel.snp.makeConstraints({
            $0.top.equalTo(self.divider.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        })
        
        weeklychangeImageView.snp.makeConstraints({
            $0.top.equalTo(self.calorieChangeDescLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(94)
        })
    }

}
