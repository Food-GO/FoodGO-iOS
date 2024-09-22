//
//  WeeklyReportChartView.swift
//  YoriJori
//
//  Created by 김강현 on 9/22/24.
//

import UIKit
import SnapKit


class WeeklyReportChartView: UIView {
    
    let lackCalorie = "-115 kcal"
    
    private lazy var descLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold18
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "섭취 권장 칼로리보다\n\(lackCalorie) 부족해요"
        $0.asColor(targetString: "\(lackCalorie)", color: DesignSystemColor.yorijoriPink)
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private lazy var recommendNutritionLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold16
        $0.text = "권장 영양정보 추이"
    }
    
    private let grayBox = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray300
    }
    
    private lazy var grayBoxDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold12
        $0.text = "권장 섭취량"
    }
    
    private let greenBox = UIView().then {
        $0.backgroundColor = DesignSystemColor.yorijoriGreen
    }
    
    private lazy var greenBoxDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold12
        $0.text = "8월 3주차"
    }
    
    private let chartView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
        $0.layer.cornerRadius = 12
    }
    
    private let detailReportButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriGreen, textColor: DesignSystemColor.white
    ).then {
        $0.text = "리포트 자세히 보기"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DesignSystemColor.white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = DesignSystemColor.gray150.cgColor
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [descLabel, divider, recommendNutritionLabel, grayBox, grayBoxDescLabel, greenBox, greenBoxDescLabel, chartView, detailReportButton].forEach({self.addSubview($0)})
        
        descLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
        })
        
        divider.snp.makeConstraints({
            $0.top.equalTo(self.descLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(1)
        })
        
        recommendNutritionLabel.snp.makeConstraints({
            $0.top.equalTo(self.divider.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(14)
        })
        
        greenBoxDescLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-14)
            $0.centerY.equalTo(self.recommendNutritionLabel.snp.centerY)
        })
        
        greenBox.snp.makeConstraints({
            $0.trailing.equalTo(self.greenBoxDescLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(8)
            $0.centerY.equalTo(self.recommendNutritionLabel.snp.centerY)
        })
        
        grayBoxDescLabel.snp.makeConstraints({
            $0.trailing.equalTo(self.greenBox.snp.leading).offset(-8)
            $0.centerY.equalTo(self.recommendNutritionLabel.snp.centerY)
        })
        
        grayBox.snp.makeConstraints({
            $0.trailing.equalTo(self.grayBoxDescLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(8)
            $0.centerY.equalTo(self.recommendNutritionLabel.snp.centerY)
        })
        
        chartView.snp.makeConstraints({
            $0.top.equalTo(self.recommendNutritionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(200)
        })
        
        detailReportButton.snp.makeConstraints({
            $0.top.equalTo(self.chartView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(42)
        })
        
        setupChartView()
    }
    
    private func setupChartView() {
        let items = [
            ("탄수화물", 80, 120),
            ("단백질", 80, 55),
            ("지방", 80, 130)
        ]
        
        for (index, item) in items.enumerated() {
            let itemView = createChartItemView(title: item.0, recommendedValue: item.1, actualValue: item.2)
            chartView.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
                itemView.heightAnchor.constraint(equalToConstant: 52)
            ])
            
            if index == 0 {
                itemView.topAnchor.constraint(equalTo: chartView.topAnchor).isActive = true
            } else {
                itemView.topAnchor.constraint(equalTo: chartView.subviews[index - 1].bottomAnchor, constant: 16).isActive = true
            }
        }
    }
    
    private func createChartItemView(title: String, recommendedValue: Int, actualValue: Int) -> UIView {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = DesignSystemFont.bold12
        titleLabel.textColor = DesignSystemColor.gray900
        
        let divider = UIView()
        divider.backgroundColor = DesignSystemColor.gray300
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let recommendedBar = UIView()
        recommendedBar.translatesAutoresizingMaskIntoConstraints = false
        recommendedBar.backgroundColor = DesignSystemColor.gray300
        recommendedBar.layer.cornerRadius = 6
        recommendedBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        let actualBar = UIView()
        actualBar.translatesAutoresizingMaskIntoConstraints = false
        actualBar.layer.cornerRadius = 6
        actualBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        actualBar.backgroundColor = DesignSystemColor.yorijoriGreen
        
        let recommendedValueLabel = UILabel()
        recommendedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendedValueLabel.text = "\(recommendedValue)g"
        recommendedValueLabel.font = DesignSystemFont.bold12
        recommendedValueLabel.textColor = DesignSystemColor.gray600
        
        let actualValueLabel = UILabel()
        actualValueLabel.translatesAutoresizingMaskIntoConstraints = false
        actualValueLabel.text = "\(actualValue)g"
        actualValueLabel.font = DesignSystemFont.bold12
        actualValueLabel.textColor = DesignSystemColor.yorijoriGreen
        
        itemView.addSubview(titleLabel)
        itemView.addSubview(divider)
        itemView.addSubview(recommendedBar)
        itemView.addSubview(actualBar)
        itemView.addSubview(recommendedValueLabel)
        itemView.addSubview(actualValueLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 60),
            
            divider.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 23),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: itemView.topAnchor),
            divider.bottomAnchor.constraint(equalTo: itemView.bottomAnchor),
            
            recommendedBar.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            recommendedBar.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 8),
            recommendedBar.widthAnchor.constraint(equalToConstant: 100),
            recommendedBar.heightAnchor.constraint(equalToConstant: 16),
            
            recommendedValueLabel.leadingAnchor.constraint(equalTo: recommendedBar.trailingAnchor, constant: 6),
            recommendedValueLabel.centerYAnchor.constraint(equalTo: recommendedBar.centerYAnchor),
            recommendedValueLabel.widthAnchor.constraint(equalToConstant: 40),
            
            actualBar.topAnchor.constraint(equalTo: recommendedBar.bottomAnchor, constant: 4),
            actualBar.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            actualBar.widthAnchor.constraint(equalToConstant: CGFloat(actualValue) / CGFloat(recommendedValue) * 100),
            actualBar.heightAnchor.constraint(equalToConstant: 16),
            
            actualValueLabel.leadingAnchor.constraint(equalTo: actualBar.trailingAnchor, constant: 6),
            actualValueLabel.centerYAnchor.constraint(equalTo: actualBar.centerYAnchor),
            actualValueLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        return itemView
    }
    
}
