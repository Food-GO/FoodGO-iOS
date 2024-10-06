//
//  IngredientTableCell.swift
//  YoriJori
//
//  Created by 김강현 on 10/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class IngredientTableCell: UITableViewCell {
    static let identifier = "IngredientTableCell"
    
    private let image = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.font = DesignSystemFont.bold16
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let quantityLabel = UILabel().then {
        $0.font = DesignSystemFont.semibold14
        $0.textColor = DesignSystemColor.gray900
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [image, nameLabel, quantityLabel].forEach { contentView.addSubview($0) }
        
        image.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.width.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(self.image.snp.top)
            $0.leading.equalTo(self.image.snp.trailing).offset(8)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.leading.equalTo(self.image.snp.trailing).offset(8)
            $0.bottom.equalTo(self.image.snp.bottom)
        }
    }
    
    func configure(with item: FoodList) {
        nameLabel.text = item.name
        quantityLabel.text = "수량 | \(item.quantity)"
        
        if let url = URL(string: item.imageUrl) {
            image.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_image"))
            image.contentMode = .scaleToFill
        } else {
            image.image = nil
        }
    }
}
