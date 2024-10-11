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
        $0.text = "10월 2주차 리포트"
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private lazy var calorieChangeDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold18
        $0.numberOfLines = 0
    }
    
    private let weeklychangeView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = DesignSystemColor.gray100
    }
    
    private let firstWeekLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold12
        $0.text = "10월 1주차"
    }
    
    private let firstWeekBar = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.backgroundColor = DesignSystemColor.gray300
    }
    
    private let firstWeekKcal = UILabel().then {
        $0.textColor = DesignSystemColor.gray700
        $0.font = DesignSystemFont.bold12
        $0.text = "1015 kcal"
    }
    
    private let secondWeekLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold12
        $0.text = "10월 2주차"
    }
    
    private let secondWeekBar = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.backgroundColor = DesignSystemColor.yorijoriPink
    }
    
    private let secondWeekKcal = UILabel().then {
        $0.textColor = DesignSystemColor.yorijoriPink
        $0.font = DesignSystemFont.bold12
        $0.text = "1095 kcal"
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
        [currentWeekLabel, divider, calorieChangeDescLabel, weeklychangeView].forEach({self.addSubview($0)})
        [firstWeekLabel, firstWeekBar, firstWeekKcal, secondWeekLabel, secondWeekBar, secondWeekKcal].forEach({self.weeklychangeView.addSubview($0)})
        
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
        
        weeklychangeView.snp.makeConstraints({
            $0.top.equalTo(self.calorieChangeDescLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(94)
        })
        
        firstWeekLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(22)
        })
        
        firstWeekBar.snp.makeConstraints({
            $0.centerY.equalTo(self.firstWeekLabel.snp.centerY)
            $0.leading.equalTo(self.firstWeekLabel.snp.trailing).offset(12)
            $0.height.equalTo(20)
            $0.width.equalTo(139)
        })
        
        firstWeekKcal.snp.makeConstraints({
            $0.centerY.equalTo(self.firstWeekLabel.snp.centerY)
            $0.leading.equalTo(self.firstWeekBar.snp.trailing).offset(6)
        })
        
        secondWeekLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-22)
        })
        
        secondWeekBar.snp.makeConstraints({
            $0.centerY.equalTo(self.secondWeekLabel.snp.centerY)
            $0.leading.equalTo(self.secondWeekLabel.snp.trailing).offset(12)
            $0.height.equalTo(20)
            $0.width.equalTo(139)
        })
        
        secondWeekKcal.snp.makeConstraints({
            $0.centerY.equalTo(self.secondWeekLabel.snp.centerY)
            $0.leading.equalTo(self.secondWeekBar.snp.trailing).offset(6)
        })
    }
    
    func update(lastWeekTotal: Float, thisWeekTotal: Float) {
        firstWeekKcal.text = String(format: "%.0f kcal", lastWeekTotal)
        secondWeekKcal.text = String(format: "%.0f kcal", thisWeekTotal)
        
        let calorieDifference = Int(thisWeekTotal - lastWeekTotal)
        let absCalorieDifference = abs(calorieDifference)
        
        if calorieDifference > 0 {
            calorieChangeDescLabel.text = "지난주 보다 총 칼로리가\n\(absCalorieDifference) kcal 늘었어요"
            calorieChangeDescLabel.asColor(targetString: "\(absCalorieDifference) kcal", color: DesignSystemColor.yorijoriPink)
        } else if calorieDifference < 0 {
            calorieChangeDescLabel.text = "지난주 보다 총 칼로리가\n\(absCalorieDifference) kcal 줄었어요"
            calorieChangeDescLabel.asColor(targetString: "\(absCalorieDifference) kcal", color: DesignSystemColor.yorijoriGreen)
        } else {
            calorieChangeDescLabel.text = "지난주와 총 칼로리가 동일해요"
        }
    }
    
}
