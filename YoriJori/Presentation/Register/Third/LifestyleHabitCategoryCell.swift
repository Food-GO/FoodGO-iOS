//
//  LifestyleHabitCategoryCell.swift
//  YoriJori
//
//  Created by 김강현 on 7/18/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class LifestyleHabitCategoryCell: UICollectionViewCell {
    
    static let identifier = "LifestyleHabitCategoryCell"
    var disposeBag = DisposeBag()
    
    let button = UIButton().then {
        $0.layer.borderColor = DesignSystemColor.borderColor.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.titleLabel?.textAlignment = .left
        $0.titleLabel?.font = DesignSystemFont.medium12
        $0.titleLabel?.textColor = DesignSystemColor.textColor
//        $0.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 0)
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
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        })
        
    }
    
    func configure(text: String, isSelected: Bool) {
        self.button.setTitle(text, for: .normal)
        self.button.setTitleColor(isSelected ? .white : DesignSystemColor.textColor, for: .normal)
        self.button.backgroundColor = isSelected ? .red : .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
