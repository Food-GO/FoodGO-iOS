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
        $0.titleLabel?.font = DesignSystemFont.semibold14
        $0.setTitleColor(DesignSystemColor.gray900, for: .normal)
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
            $0.edges.equalToSuperview()
        })
        
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func configure(text: String, isSelected: Bool) {
        self.button.setTitle(text, for: .normal)
//        self.button.setTitleColor(isSelected ? .white : DesignSystemColor.textColor, for: .normal)
        self.button.layer.borderColor = isSelected ? DesignSystemColor.yorijoriPink.cgColor : DesignSystemColor.borderColor.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}


