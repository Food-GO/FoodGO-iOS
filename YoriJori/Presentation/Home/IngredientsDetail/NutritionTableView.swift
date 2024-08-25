//
//  NutritionTableView.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit

class NutritionTableView: UITableView {
    
    private let nutritionData: [(String, String, String, String)] = [
        ("탄수화물", "", "나트륨", ""),
        ("단백질", "", "콜레스테롤", ""),
        ("지방", "", "포화지방", ""),
        ("당류", "", "트랜스지방", "")
    ]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        self.dataSource = self
        self.delegate = self
        self.register(NutritionTableViewCell.self, forCellReuseIdentifier: "NutritionCell")
        self.separatorStyle = .none
        self.isScrollEnabled = false
    }
}

extension NutritionTableView: UITableViewDataSource, UITableViewDelegate {
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
