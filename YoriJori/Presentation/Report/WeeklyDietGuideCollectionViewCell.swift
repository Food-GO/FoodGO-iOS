//
//  WeeklyDietGuideCollectionViewCell.swift
//  YoriJori
//
//  Created by 김강현 on 9/22/24.
//

import UIKit
import SnapKit

class WeeklyDietGuideCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeeklyDietGuideCollectionViewCell"
    
    private let mealTimeLabel = UILabel().then {
        $0.textColor = DesignSystemColor.yorijoriPink
        $0.font = DesignSystemFont.bold14
    }
    
    private let descLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.medium14
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = DesignSystemColor.white
        self.layer.cornerRadius = 12
        self.layer.borderColor = DesignSystemColor.gray150.cgColor
        self.layer.borderWidth = 1
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [mealTimeLabel, descLabel].forEach({self.contentView.addSubview($0)})
        
        mealTimeLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
        })
        
        descLabel.snp.makeConstraints({
            $0.top.equalTo(self.mealTimeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(14)
        })
    }
    
    func configure(mealTime: String, desc: String) {
        mealTimeLabel.text = mealTime
        descLabel.text = desc
    }
}
