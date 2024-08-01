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
    private var bgColor: UIColor
    private var textColor: UIColor
    private var borderColor: UIColor
    
    var text: String = "" {
        didSet {
            setTitle()
        }
    }
    
    // MARK: - Initializer
    init(bgColor: UIColor, textColor: UIColor, borderColor: UIColor) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.borderColor = borderColor
        super.init(frame: .zero)
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
        titleContainer.font = DesignSystemFont.subTitle1
        titleContainer.foregroundColor = textColor
        buttonConfig.titleAlignment = .center
        
        buttonConfig.attributedTitle = AttributedString(text, attributes: titleContainer)
        self.configuration = buttonConfig
    }
    
    private func setBorderColor() {
        buttonConfig.background.strokeColor = borderColor
        buttonConfig.background.strokeWidth = 1
    }
    
    private func setBackgroundColor() {
        buttonConfig.baseBackgroundColor = bgColor
    }
    
}
