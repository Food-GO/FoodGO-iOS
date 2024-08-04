//
//  YorijoriButton.swift
//  YoriJori
//
//  Created by 김강현 on 7/25/24.
//

import UIKit

final class YorijoriButton: UIButton {
    // MARK: - Property
    private var buttonConfig = UIButton.Configuration.filled()
    private var bgColor: UIColor
    private var textColor: UIColor
    private var borderColor: UIColor
    private var selectedBorderColor: UIColor
    
    
    var text: String = "" {
        didSet {
            setTitle()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Initializer
    init(bgColor: UIColor, textColor: UIColor, borderColor: UIColor, selectedBorderColor: UIColor) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
        super.init(frame: .zero)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialState() {
        buttonConfig.background.backgroundColor = bgColor
        buttonConfig.baseForegroundColor = textColor
        buttonConfig.background.strokeColor = borderColor
        buttonConfig.background.strokeWidth = 1
        setTitle()
        updateAppearance()
        self.configuration = buttonConfig
    }
    
    private func setTitle() {
        var titleContainer = AttributeContainer()
        titleContainer.font = DesignSystemFont.subTitle1
        titleContainer.foregroundColor = textColor
        buttonConfig.titleAlignment = .center
        buttonConfig.attributedTitle = AttributedString(text, attributes: titleContainer)
        self.configuration = buttonConfig
    }
    
    private func updateAppearance() {
        buttonConfig.background.strokeColor = isSelected ? selectedBorderColor : borderColor
        buttonConfig.baseForegroundColor = textColor
        self.configuration = buttonConfig
    }
    
}
