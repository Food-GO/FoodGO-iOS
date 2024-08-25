//
//  NutritionTableViewCell.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit
import SnapKit

class NutritionTableViewCell: UITableViewCell {
    private let leftLabel = UILabel()
    private let leftValueLabel = UILabel()
    private let rightLabel = UILabel()
    private let rightValueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [leftLabel, leftValueLabel, rightLabel, rightValueLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            leftValueLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 8),
            leftValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 16),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightValueLabel.leadingAnchor.constraint(equalTo: rightLabel.trailingAnchor, constant: 8),
            rightValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        self.addBorder(edges: [.bottom], color: DesignSystemColor.gray200, thickness: 0.5)
    }
    
    func configure(leftLabel: String, leftValue: String, rightLabel: String, rightValue: String) {
        self.leftLabel.text = leftLabel
        self.leftValueLabel.text = leftValue
        self.rightLabel.text = rightLabel
        self.rightValueLabel.text = rightValue
    }
}
