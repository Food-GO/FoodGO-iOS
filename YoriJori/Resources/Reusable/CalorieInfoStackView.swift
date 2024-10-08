//
//  CalorieInfoStackView.swift
//  YoriJori
//
//  Created by 김강현 on 8/23/24.
//

import UIKit
import SnapKit

class CalorieInfoStackView: UIStackView {
    
    private let titleLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold14
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray900
    }
    
    private let detailLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.medium14
        
    }
    
    init(title: String, amountText: String) {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.spacing = 4
        self.distribution = .equalSpacing
        self.alignment = .center
        
        self.titleLabel.text = title
        self.detailLabel.text = amountText
        
        [titleLabel, divider, detailLabel].forEach({self.addArrangedSubview($0)})
        
        self.divider.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(1)
            $0.height.equalTo(13)
        })
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
