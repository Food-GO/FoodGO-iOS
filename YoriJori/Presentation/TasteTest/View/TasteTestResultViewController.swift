//
//  TasteTestResultViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TasteTestResultViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let characterBackgroundView = UIView().then {
        $0.layer.cornerRadius = 12
    }
    
    private let shareButton = UIButton().then {
        $0.setImage(UIImage(named: "share"), for: .normal)
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
    
    private let reTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray600).then {
        $0.text = "테스트 다시하기"
        $0.semanticContentAttribute = .forceRightToLeft
        $0.setImage(UIImage(named: "return"), for: .normal)
    }
    
    private let applyTasteButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "취향 적용하기"
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
        
        shareButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.showBottomSheet()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        self.title = "취향 테스트"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    private func setUI() {
        [characterBackgroundView, reTestButton, applyTasteButton].forEach({self.view.addSubview($0)})
        [nameLabel, typeDescLabel, typeLabel, typeUnderLine, characterImageView, shareButton].forEach({self.characterBackgroundView.addSubview($0)})
        
        characterBackgroundView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(54)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(483)
        })
        
        shareButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(36)
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
        
        reTestButton.snp.makeConstraints({
            $0.top.equalTo(self.characterBackgroundView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(110)
            $0.height.equalTo(40)
        })
        
        applyTasteButton.snp.makeConstraints({
            $0.top.equalTo(self.reTestButton.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    private func showBottomSheet() {
        let bottomSheet = ShareBottomSheetViewController()
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        bottomSheet.optionSelected
            .subscribe(onNext: { [weak self] option in
                self?.handleSelectedOption(option)
                bottomSheet.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func handleSelectedOption(_ option: String) {
        switch option {
        case "home":
            self.navigationController?.popToRootViewController(animated: true)
        default:
            break
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
