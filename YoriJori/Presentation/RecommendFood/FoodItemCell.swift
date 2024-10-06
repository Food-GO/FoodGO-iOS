//
//  FoodItemCell.swift
//  YoriJori
//
//  Created by 김강현 on 10/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class FoodItemCell: UICollectionViewCell {
    static let identifier = "FoodItemCell"
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let nameLabel = UILabel()
    private let quantityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [imageView, nameLabel, quantityLabel].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.height.width.equalTo(48)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalTo(self.imageView.snp.trailing).offset(8)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.leading.equalTo(self.imageView.snp.trailing).offset(8)
            $0.bottom.equalTo(self.imageView.snp.bottom)
        }
        
        nameLabel.font = DesignSystemFont.bold14
        quantityLabel.font = DesignSystemFont.semibold14
        quantityLabel.textColor = DesignSystemColor.gray900
    }
    
    func configure(with item: FoodList) {
        nameLabel.text = item.name
        quantityLabel.text = "수량 | \(item.quantity)"
        
        if let url = URL(string: item.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_image"))
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = nil
        }
    }
}
