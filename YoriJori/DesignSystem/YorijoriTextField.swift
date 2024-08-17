//
//  YorijoriTextField.swift
//  YoriJori
//
//  Created by 김강현 on 8/2/24.
//

import UIKit

class YorijoriTextField: UITextField {

    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemColor.gray150
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        self.leftViewMode = .always
        self.font = DesignSystemFont.medium14
        self.textColor = DesignSystemColor.gray500
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
