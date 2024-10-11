//
//  IngredientsReportView.swift
//  YoriJori
//
//  Created by 김강현 on 10/11/24.
//
import UIKit
import SnapKit

class IngredientsReportView: UIView {
    
    private var chartItemViews: [UIView] = []
    
    private lazy var recommendNutritionLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold16
        $0.text = "영양정보 리포트"
    }
    
    private let grayBox = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray300
    }
    
    private lazy var grayBoxDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold12
        $0.text = "10월 1주차"
    }
    
    private let greenBox = UIView().then {
        $0.backgroundColor = DesignSystemColor.yorijoriGreen
    }
    
    private lazy var greenBoxDescLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold12
        $0.text = "10월 2주차"
    }
    
    private let chartView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
        $0.layer.cornerRadius = 12
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DesignSystemColor.white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [recommendNutritionLabel, grayBox, grayBoxDescLabel, greenBox, greenBoxDescLabel, chartView].forEach({self.addSubview($0)})
        
        recommendNutritionLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
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
            $0.height.equalTo(550)
        })
        
        setupChartView()
    }
    
    private func setupChartView() {
        let items = [
            ("탄수화물", 0, 0),
            ("단백질", 0, 0),
            ("지방", 0, 0),
            ("당류", 0, 0),
            ("나트륨", 0, 0),
            ("콜레스테롤", 0, 0),
            ("포화지방", 0, 0),
            ("트랜스지방", 0, 0)
        ]
        
        
        for (index, item) in items.enumerated() {
            let itemView = createChartItemView(title: item.0, recommendedValue: Float(item.1), actualValue: Float(item.2))
            chartView.addSubview(itemView)
            chartItemViews.append(itemView)

            itemView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(chartView)
                make.height.equalTo(52)
                
                if index == 0 {
                    make.top.equalTo(chartView)
                } else {
                    make.top.equalTo(chartItemViews[index - 1].snp.bottom).offset(16)
                }
            }
        }
        if let lastItem = chartItemViews.last {
            lastItem.snp.makeConstraints { make in
                make.bottom.equalTo(chartView)
            }
        }
    }
    
    private func createChartItemView(title: String, recommendedValue: Float, actualValue: Float) -> UIView {
        let itemView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = DesignSystemFont.bold12
        titleLabel.textColor = DesignSystemColor.gray900
        
        let divider = UIView()
        divider.backgroundColor = DesignSystemColor.gray300
        
        let recommendedBar = UIView()
        recommendedBar.backgroundColor = DesignSystemColor.gray300
        recommendedBar.layer.cornerRadius = 6
        recommendedBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        let actualBar = UIView()
        actualBar.layer.cornerRadius = 6
        actualBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        actualBar.backgroundColor = DesignSystemColor.yorijoriGreen
        
        let recommendedValueLabel = UILabel()
        recommendedValueLabel.text = String(format: "%.1fg", recommendedValue)
        recommendedValueLabel.font = DesignSystemFont.bold12
        recommendedValueLabel.textColor = DesignSystemColor.gray600
        
        let actualValueLabel = UILabel()
        actualValueLabel.text = String(format: "%.1fg", actualValue)
        actualValueLabel.font = DesignSystemFont.bold12
        actualValueLabel.textColor = DesignSystemColor.yorijoriGreen
        
        itemView.addSubview(titleLabel)
        itemView.addSubview(divider)
        itemView.addSubview(recommendedBar)
        itemView.addSubview(actualBar)
        itemView.addSubview(recommendedValueLabel)
        itemView.addSubview(actualValueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(23)
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
        }
        
        recommendedBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(divider.snp.trailing)
            make.height.equalTo(16)
            make.width.equalTo(10) 
        }
        
        actualBar.snp.makeConstraints { make in
            make.top.equalTo(recommendedBar.snp.bottom).offset(4)
            make.leading.equalTo(divider.snp.trailing)
            make.height.equalTo(16)
            make.width.equalTo(10)
        }
        
        recommendedValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(recommendedBar.snp.trailing).offset(6)
            make.centerY.equalTo(recommendedBar)
        }
        
        actualValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(actualBar.snp.trailing).offset(6)
            make.centerY.equalTo(actualBar)
        }
        
        return itemView
    }
    
    func update(with report: IngredientReport) {
        let items: [(String, Float, Float)] = [
            ("탄수화물", report.lastWeekCarbs, report.thisWeekCarbs),
            ("단백질", report.lastWeekProteins, report.thisWeekProteins),
            ("지방", report.lastWeekFats, report.thisWeekFats),
            ("당류", report.lastWeekSugar, report.thisWeekSugar),
            ("나트륨", report.lastWeekSodium, report.thisWeekSodium),
            ("콜레스테롤", report.lastWeekCholesterol, report.thisWeekCholesterol),
            ("포화지방", report.lastWeekSaturatedFat, report.thisWeekSaturatedFat),
            ("트랜스지방", report.lastWeekTransFat, report.thisWeekTransFat)
        ]
        
        for (index, item) in items.enumerated() {
            updateChartItemView(chartItemViews[index], title: item.0, lastWeekValue: item.1, thisWeekValue: item.2)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        print("Layout updated")
    }
    
    private func updateChartItemView(_ itemView: UIView, title: String, lastWeekValue: Float, thisWeekValue: Float) {
        guard let titleLabel = itemView.subviews.first(where: { $0 is UILabel }) as? UILabel,
              let recommendedBar = itemView.subviews.first(where: { $0.backgroundColor == DesignSystemColor.gray300 && $0.layer.cornerRadius == 6 }),
              let actualBar = itemView.subviews.first(where: { $0.backgroundColor == DesignSystemColor.yorijoriGreen }),
              let recommendedValueLabel = itemView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.textColor == DesignSystemColor.gray600 }),
              let actualValueLabel = itemView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.textColor == DesignSystemColor.yorijoriGreen }) else {
            return
        }
        
        titleLabel.text = title
        recommendedValueLabel.text = String(format: "%.1fg", lastWeekValue)
        actualValueLabel.text = String(format: "%.1fg", thisWeekValue)
        
        let minBarWidth: CGFloat = 10
        let maxBarWidth: CGFloat = 150
        let maxValue: Float = 300
        
        func calculateBarWidth(_ value: Float) -> CGFloat {
            if value == 0 {
                return minBarWidth
            }
            let normalizedValue = min(value, maxValue) / maxValue
            return minBarWidth + CGFloat(normalizedValue) * (maxBarWidth - minBarWidth)
        }
        
        let recommendedBarWidth = calculateBarWidth(lastWeekValue)
        let actualBarWidth = calculateBarWidth(thisWeekValue)
        
        recommendedBar.snp.updateConstraints { make in
            make.width.equalTo(recommendedBarWidth)
        }
        
        actualBar.snp.updateConstraints { make in
            make.width.equalTo(actualBarWidth)
        }
        
        itemView.layoutIfNeeded()
        
        print("Updated bar widths for \(title) - recommended: \(recommendedBarWidth), actual: \(actualBarWidth)")
    }
}
