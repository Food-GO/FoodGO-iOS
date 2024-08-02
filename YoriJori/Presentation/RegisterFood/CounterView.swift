//
//  CounterView.swift
//  YoriJori
//
//  Created by 김강현 on 8/2/24.
//

import UIKit

class CounterView: UIView {
    
    private var count = 1
    
    var onCountChanged: ((Int) -> Void)?
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minus_circle"), for: .normal)
        button.addTarget(self, action: #selector(decreaseCount), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_circle"), for: .normal)
        button.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(count)"
        label.textColor = DesignSystemColor.gray800
        label.font = DesignSystemFont.medium14
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DesignSystemColor.gray150
        self.layer.cornerRadius = 12
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightAnchor.constraint(equalToConstant: 46),
            
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
    
    @objc private func decreaseCount() {
        count -= 1
        updateCountLabel()
    }
    
    @objc private func increaseCount() {
        count += 1
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        countLabel.text = "\(count)"
        onCountChanged?(count)
    }
}
