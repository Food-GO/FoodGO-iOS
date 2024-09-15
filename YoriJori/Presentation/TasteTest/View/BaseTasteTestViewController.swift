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
    
    private let firstSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100, selectedBorderColor: DesignSystemColor.yorijoriGreen)
    
    private let secondSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100, selectedBorderColor: DesignSystemColor.yorijoriGreen)
    
    private let thirdSelectButton = YorijoriButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray900, borderColor: DesignSystemColor.gray100, selectedBorderColor: DesignSystemColor.yorijoriGreen)
    
    private let nextButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white)
    
    private let viewModel = TasteTestViewModel()
    private let disposeBag = DisposeBag()
    
    private let smallLogo = UIImageView().then {
        $0.image = UIImage(named: "yorijori_small_logo")
    }
    
    private let progressNumber = UILabel().then {
        $0.textColor = DesignSystemColor.white
        $0.font = DesignSystemFont.title3
    }
    
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
        self.nextButton.setTitleColor(DesignSystemColor.white, for: .normal)
        
        let stepNumber = Int(step * 10)
        self.progressNumber.text = "\(stepNumber)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        setUI()
        setupNextButtonAction()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        [progressBar, smallLogo, questionLabel, firstSelectButton, secondSelectButton, thirdSelectButton, nextButton].forEach({self.view.addSubview($0)})
        self.smallLogo.addSubview(progressNumber)
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(4)
        })
        
        smallLogo.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(63)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(32)
        })
        
        progressNumber.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        questionLabel.snp.makeConstraints({
            $0.top.equalTo(self.smallLogo.snp.bottom).offset(12)
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
            button.isSelected = (index == selectedIndex)
            button.setNeedsUpdateConfiguration()
        }
    }
    
    @objc func nextButtonTapped() {
        
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
