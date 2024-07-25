//
//  YorijoriButton.swift
//  YoriJori
//
//  Created by 김강현 on 7/25/24.
//

import UIKit

final class YorijoriButton: UIButton {
    // MARK: - Property
    private var buttonConfig = UIButton.Configuration.borderedTinted()
    
    var text: String = "" {
        didSet {
            setTitle()
        }
    }
    
//    var isDisabled: Bool = false {
//        didSet {
//            self.isEnabled = !isDisabled
//            setBackgroundColor()
//        }
//    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle()
        setBackgroundColor()
        setBorderColor()
        self.configuration = buttonConfig
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func setTitle() {
        var titleContainer = AttributeContainer()
        titleContainer.font = DesignSystemFont.subTitle2
        titleContainer.foregroundColor = DesignSystemColor.yorijoriPink
        buttonConfig.titleAlignment = .center
        
        buttonConfig.attributedTitle = AttributedString(text, attributes: titleContainer)
        self.configuration = buttonConfig
    }
    
    private func setBorderColor() {
        buttonConfig.background.strokeColor = DesignSystemColor.yorijoriPink
        buttonConfig.background.strokeWidth = 1
    }
    
    private func setBackgroundColor() {
        buttonConfig.baseBackgroundColor = DesignSystemColor.white
    }
    
    func setBackground(color: UIColor) {
        buttonConfig.baseBackgroundColor = color
    }
}
