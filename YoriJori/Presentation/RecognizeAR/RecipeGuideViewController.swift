//
//  RecipeGuideViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RecipeGuideViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 24
    }
    
    private let headerLeftChevron = UIImageView().then {
        $0.image = UIImage(named: "chevron_left")
    }
    
    private let headerTitle = UILabel().then {
        $0.font = DesignSystemFont.bold18
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let headerRightChevron = UIImageView().then {
        $0.image = UIImage(named: "chevron_right")
    }
    
    private let contentsContainer = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemColor.gray150.cgColor
    }
    
    private let contentsLabel = UILabel().then {
        $0.font = DesignSystemFont.semibold16
        $0.textColor = DesignSystemColor.gray900
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    init(headerTitle: String, contentsText: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.headerTitle.text = headerTitle
        self.contentsLabel.text = contentsText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        [containerView, closeButton].forEach({self.view.addSubview($0)})
        
        containerView.snp.makeConstraints ({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(200)
        })
        
        closeButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(28)
        })
        
        [headerStackView, contentsContainer].forEach({self.containerView.addSubview($0)})
        contentsContainer.addSubview(contentsLabel)
        [headerLeftChevron, headerTitle, headerRightChevron].forEach({self.headerStackView.addArrangedSubview($0)})
        
        headerStackView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(27)
        })
        
        headerLeftChevron.snp.makeConstraints({
            $0.width.height.equalTo(24)
        })
        
        headerRightChevron.snp.makeConstraints({
            $0.width.height.equalTo(24)
        })
        
        contentsContainer.snp.makeConstraints({
            $0.top.equalTo(self.headerStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(104)
        })
        
        contentsLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        })
        
    }
    
    private func bindButtons() {
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

