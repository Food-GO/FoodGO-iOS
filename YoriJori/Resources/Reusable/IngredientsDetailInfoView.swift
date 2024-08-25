//
//  IngredientsDetailInfoView.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit
import SnapKit

class IngredientsDetailInfoView: UIView {
    
    private let foodImage = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let foodName = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let foodAmount = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold14
    }
    
    private let totalCalorie = UILabel().then {
        $0.textColor = DesignSystemColor.gray800
        $0.font = DesignSystemFont.bold14
    }
    
    private let nutritionTableView = NutritionTableView()
    
    private var nutritionData: [(String, String, String, String)] = []
    
    init(model: IngredientsDetailModel) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemColor.white
        
        setUI()
        configureWithModel(model)
        setupTableView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [foodImage, foodName, foodAmount, totalCalorie, nutritionTableView].forEach({self.addSubview($0)})
        
        foodImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
            $0.width.height.equalTo(68)
        })
        
        foodName.snp.makeConstraints({
            $0.top.equalTo(self.foodImage.snp.top).offset(2)
            $0.leading.equalTo(self.foodImage.snp.trailing).offset(10)
        })
        
        foodAmount.snp.makeConstraints({
            $0.top.equalTo(self.foodName.snp.bottom).offset(4)
            $0.leading.equalTo(self.foodImage.snp.trailing).offset(10)
        })
        
        totalCalorie.snp.makeConstraints({
            $0.top.equalTo(self.foodAmount.snp.bottom).offset(4)
            $0.leading.equalTo(self.foodImage.snp.trailing).offset(10)
        })
        
        nutritionTableView.snp.makeConstraints({
            $0.top.equalTo(self.foodImage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(160)
        })
    }
    
    private func configureWithModel(_ model: IngredientsDetailModel) {
        foodImage.image = model.foodImage
        foodName.text = model.foodName
        foodAmount.text = model.foodAmount
        totalCalorie.text = model.totalCalorie
        
        nutritionData = [
            ("탄수화물", model.carbohydrates, "나트륨", model.nat),
            ("단백질", model.protein, "콜레스테롤", model.cholesterol),
            ("지방", model.fat, "포화지방", model.saturatedFat),
            ("당류", model.sugars, "트랜스지방", model.transFats)
        ]
        
        nutritionTableView.reloadData()
    }
    
    private func setupTableView() {
        nutritionTableView.dataSource = self
        nutritionTableView.delegate = self
        nutritionTableView.register(NutritionTableViewCell.self, forCellReuseIdentifier: "NutritionCell")
        nutritionTableView.separatorStyle = .none
        nutritionTableView.isScrollEnabled = false
    }
}

extension IngredientsDetailInfoView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCell", for: indexPath) as! NutritionTableViewCell
        let data = nutritionData[indexPath.row]
        cell.configure(leftLabel: data.0, leftValue: data.1, rightLabel: data.2, rightValue: data.3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
