//
//  RegistIdPasswordViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class IDPasswordViewController: BaseViewController {
    
    private let viewModel = IDPasswordViewModel()
    private let disposeBag = DisposeBag()
    
    private let progressBar = UISlider().then {
        $0.thumbTintColor = .clear
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.setValue(0.25, animated: false)
        $0.minimumTrackTintColor = .red.withAlphaComponent(0.5)
        $0.isUserInteractionEnabled = false
    }
    
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let idStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let idTextField = YorijoriTextField().then {
        $0.placeholder = "아이디를 입력해주세요"
    }
    
    private let idValidateButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(DesignSystemColor.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = DesignSystemFont.semibold14
        $0.backgroundColor = DesignSystemColor.gray500
    }
    
    private let pwLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let pwTextField = YorijoriTextField().then {
        $0.placeholder = "비밀번호를 입력해주세요(10자 이상)"
        $0.isSecureTextEntry = true
    }
    
    private let pwValidateLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let pwValidateTextField = YorijoriTextField().then {
        $0.placeholder = "위와 동일한 비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }
    
    private lazy var nextButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.setTitle("다음", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 12
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupNavigationBar()
        setUI()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        [progressBar, idLabel, idStackView, pwLabel, pwTextField, pwValidateLabel, pwValidateTextField, nextButton].forEach({self.view.addSubview($0)})
        [idTextField, idValidateButton].forEach({self.idStackView.addArrangedSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        idLabel.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(15)
        })
        
        idTextField.snp.makeConstraints({
            $0.width.equalTo(256)
            $0.height.equalTo(50)
        })
        
        idValidateButton.snp.makeConstraints({
            $0.height.equalTo(50)
        })
        
        idStackView.snp.makeConstraints({
            $0.top.equalTo(self.idLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        pwLabel.snp.makeConstraints({
            $0.top.equalTo(self.idStackView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(15)
        })
        
        pwTextField.snp.makeConstraints({
            $0.top.equalTo(self.pwLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        pwValidateLabel.snp.makeConstraints({
            $0.top.equalTo(self.pwTextField.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(15)
        })
        
        pwValidateTextField.snp.makeConstraints({
            $0.top.equalTo(self.pwValidateLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
        })
    }
    
    private func bindViewModel() {
        idTextField.rx.text.orEmpty
            .bind(to: viewModel.idRelay)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordRelay)
            .disposed(by: disposeBag)
        
        pwValidateTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordValidateRelay)
            .disposed(by: disposeBag)
        
        idValidateButton.rx.tap
            .bind(to: viewModel.validateIDTrigger)
            .disposed(by: disposeBag)
        
        viewModel.isValidateIdButtonEnabled
            .bind(to: idValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateIdButtonEnabled
            .map { $0 ? DesignSystemColor.yorijoriPink : DesignSystemColor.gray400 }
            .bind(to: idValidateButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .map { $0 ? DesignSystemColor.yorijoriPink : DesignSystemColor.gray400 }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isIDDuplicated
            .subscribe(onNext: { [weak self] isDuplicated in
                self?.updateUIForDuplicationCheck(isDuplicated)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUIForDuplicationCheck(_ isDuplicated: Bool) {
        if isDuplicated {
            idValidateButton.backgroundColor = DesignSystemColor.yorijoriPink
            idValidateButton.setTitle("중복 확인", for: .normal)
            
            AlertManager.shared.showAlert(
                on: self,
                title: "이미 사용중인 아이디입니다.",
                message: "다른 아이디를 입력해주세요."
            )
        } else {
            idValidateButton.setTitle("사용 가능", for: .normal)
        }
    }
    
    @objc private func nextButtonTapped() {
        let nextVC = ProfileNicknameViewController()
        if let id = self.idTextField.text {
            UserDefaultsManager.shared.id = id
        } else {
            print("id 값 없음")
        }
        
        if let pw = self.pwValidateTextField.text {
            UserDefaultsManager.shared.password = pw
        } else {
            print("pw 값 없음")
        }
        
        print("username: \(UserDefaultsManager.shared.id)")
        print("password: \(UserDefaultsManager.shared.password)")
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
