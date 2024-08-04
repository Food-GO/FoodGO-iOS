//
//  TasteTestResultViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/29/24.
//

import UIKit
import SnapKit

class TasteTestResultViewController: UIViewController {
    
    private let characterBackgroundView = UIView().then {
        $0.layer.cornerRadius = 12
    }
    
    private let characterImageView = UIImageView()
    
    private let nameLabel = UILabel().then {
        $0.text = "이OO님은,"
        $0.font = DesignSystemFont.extraBold20
        $0.textColor = DesignSystemColor.gray100
    }
    
    private let typeDescLabel = UILabel().then {
        $0.font = DesignSystemFont.title3
        $0.textColor = DesignSystemColor.gray100
    }
    
    private let typeLabel = UILabel().then {
        $0.font = UIFont.suit(.bold, size: 28)
    }
    
    private let typeUnderLine = UIImageView().then {
        $0.image = UIImage(named: "type_underLine")
    }
    
    init(bgColor: UIColor, characterImage: UIImage, typeTextColor: UIColor, type: String, typeDesc: String) {
        self.characterBackgroundView.backgroundColor = bgColor
        self.characterImageView.image = characterImage
        self.typeLabel.textColor = typeTextColor
        self.typeDescLabel.text = typeDesc
        self.typeLabel.text = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        setUI()
        
    }
    
    private func setupNavigationBar() {
        self.title = "취향 테스트"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    private func setUI() {
        [characterBackgroundView].forEach({self.view.addSubview($0)})
        [nameLabel, typeDescLabel, typeLabel, typeUnderLine, characterImageView].forEach({self.characterBackgroundView.addSubview($0)})
        
        characterBackgroundView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(54)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(483)
        })
        
        nameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        })
        
        typeDescLabel.snp.makeConstraints({
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        })
        
        typeLabel.snp.makeConstraints({
            $0.top.equalTo(self.typeDescLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        })
        
        typeUnderLine.snp.makeConstraints({
            $0.top.equalTo(self.typeLabel.snp.bottom).offset(7)
            $0.width.equalTo(180)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
        })
        
        characterImageView.snp.makeConstraints({
            $0.top.equalTo(self.typeUnderLine.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(27)
            $0.height.equalTo(269)
        })
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
