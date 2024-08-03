//
//  UnitSelectorView.swift
//  YoriJori
//
//  Created by 김강현 on 8/3/24.
//

import UIKit

class UnitSelectorView: UIView {
    
    private let units = ["개", "g"]
    var selectedUnit: String = "개"
    
    var onUnitSelected: ((String) -> Void)?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개 ▼", for: .normal)
        button.setTitleColor(DesignSystemColor.gray900, for: .normal)
        button.titleLabel?.font = DesignSystemFont.medium14
        button.backgroundColor = DesignSystemColor.gray150
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(showUnitPicker), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func showUnitPicker() {
        let alertController = UIAlertController(title: "단위 선택", message: nil, preferredStyle: .actionSheet)
        
        for unit in units {
            let action = UIAlertAction(title: unit, style: .default) { [weak self] _ in
                self?.selectedUnit = unit
                self?.button.setTitle("\(unit) ▼", for: .normal)
                self?.onUnitSelected?(unit)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let viewController = self.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
