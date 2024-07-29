//
//  DiseaseCategoryCell.swift
//  YoriJori
//
//  Created by 김강현 on 7/16/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class DiseaseCategoryCell: UICollectionViewCell {
    
    static let identifier = "DiseaseCategoryCell"
    var disposeBag = DisposeBag()
    
    let button = UIButton().then {
        $0.layer.borderColor = DesignSystemColor.borderColor.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = DesignSystemFont.subTitle1
        $0.titleLabel?.textColor = DesignSystemColor.gray900
        $0.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        $0.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        setupButton()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.contentView.addSubview(button)
        
        button.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
    }
    
    func configure(text: String, isSelected: Bool) {
        self.button.setTitle(text, for: .normal)
        self.button.setTitleColor(isSelected ? .white : DesignSystemColor.textColor, for: .normal)
        self.button.backgroundColor = isSelected ? DesignSystemColor.yorijoriPink : .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}


