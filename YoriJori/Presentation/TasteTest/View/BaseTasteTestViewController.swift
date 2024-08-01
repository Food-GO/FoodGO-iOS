//
//  BaseTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseTasteTestViewController: UIViewController {
    
    private let firstSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100)
    private let secondSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100)
    private let thirdSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100)
    private let nextButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white)
    
    private let viewModel = TasteTestViewModel()
    private let disposeBag = DisposeBag()
    
    private let progressBar = UISlider().then {
        $0.thumbTintColor = .clear
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.minimumTrackTintColor = DesignSystemColor.yorijoriPink
        $0.isUserInteractionEnabled = false
    }
    
    private let questionLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.title1
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    
    init(step: Float, questionText: String, firstChoice: String, secondChoice: String, thirdChoice: String, nextButtonText: String = "다음") {
        super.init(nibName: nil, bundle: nil)
        
        self.progressBar.setValue(step, animated: false)
        self.questionLabel.text = questionText
        self.firstSelectButton.setTitle(firstChoice, for: .normal)
        self.secondSelectButton.setTitle(secondChoice, for: .normal)
        self.thirdSelectButton.setTitle(thirdChoice, for: .normal)
        self.nextButton.setTitle(nextButtonText, for: .normal)
        
//        [firstSelectButton, secondSelectButton, thirdSelectButton].forEach({$0.setTitleColor(DesignSystemColor.yorijoriPink, for: .normal)})
//        [firstSelectButton, secondSelectButton, thirdSelectButton].forEach({$0.setTitleColor(DesignSystemColor.yorijoriGreen, for: .selected)})
        
        self.nextButton.setTitleColor(DesignSystemColor.white, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.white
        setUI()
        setupNextButtonAction()
        bindViewModel()
    }
    
    private func setUI() {
        [progressBar, questionLabel, firstSelectButton, secondSelectButton, thirdSelectButton, nextButton].forEach({self.view.addSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        questionLabel.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(57)
            $0.leading.trailing.equalToSuperview().inset(60)
        })
        
        firstSelectButton.snp.makeConstraints({
            $0.top.equalTo(self.questionLabel.snp.bottom).offset(47)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.equalTo(54)
        })
        
        secondSelectButton.snp.makeConstraints({
            $0.top.equalTo(self.firstSelectButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.equalTo(54)
        })
        
        thirdSelectButton.snp.makeConstraints({
            $0.top.equalTo(self.secondSelectButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.equalTo(54)
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
        })
    }
    
    private func setupNextButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.selectedButtonIndex
            .subscribe(onNext: { [weak self] index in
                self?.updateButtonStates(selectedIndex: index)
            })
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        firstSelectButton.rx.tap
            .map { 0 }
            .bind(to: viewModel.selectedButtonIndex)
            .disposed(by: disposeBag)
        
        secondSelectButton.rx.tap
            .map { 1 }
            .bind(to: viewModel.selectedButtonIndex)
            .disposed(by: disposeBag)
        
        thirdSelectButton.rx.tap
            .map { 2 }
            .bind(to: viewModel.selectedButtonIndex)
            .disposed(by: disposeBag)
        
    }
    
    private func updateButtonStates(selectedIndex: Int?) {
        let buttons = [firstSelectButton, secondSelectButton, thirdSelectButton]
        
        buttons.enumerated().forEach { index, button in
            if index == selectedIndex {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    @objc func nextButtonTapped() {
        
    }
    
    
    
}
