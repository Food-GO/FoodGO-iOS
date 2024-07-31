//
//  YorijoriFilledButton.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit


final class YorijoriFilledButton: UIButton {
    // MARK: - Property
    private var buttonConfig = UIButton.Configuration.filled()
    private var bgColor: UIColor
    private var textColor: UIColor
    
    var text: String = "" {
        didSet {
            setTitle()
        }
    }
    
    var isDisabled: Bool = false {
        didSet {
            self.isEnabled = !isDisabled
            setBackgroundColor()
        }
    }
    
    init(bgColor: UIColor, textColor: UIColor) {
        self.bgColor = bgColor
        self.textColor = textColor
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
        titleContainer.font = DesignSystemFont.subTitle3
        titleContainer.foregroundColor = textColor
        buttonConfig.titleAlignment = .center
        
        buttonConfig.attributedTitle = AttributedString(text, attributes: titleContainer)
        self.configuration = buttonConfig
    }
    
    private func setBorderColor() {

    }
    
    private func setBackgroundColor() {
        buttonConfig.baseBackgroundColor = isDisabled ? DesignSystemColor.gray400 : bgColor
    }
    
}
