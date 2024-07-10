//
//  RegistIdPasswordViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol FirstRegistViewControllerDelegate {
    func didCompleteFirstStep()
}

class FirstRegistViewController: UIViewController {
    
    var delegate: FirstRegistViewControllerDelegate?
    
    private let viewModel = FirstRegistViewModel()
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
    }
    
    private let idStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let idTextField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
    }
    
    private let idValidateButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.backgroundColor = .red.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
    }
    
    private let pwLabel = UILabel().then {
        $0.text = "비밀번호"
    }
    
    private let pwTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요(10자 이상)"
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
    }
    
    private let pwValidateLabel = UILabel().then {
        $0.text = "비밀번호 확인"
    }
    
    private let pwValidateTextField = UITextField().then {
        $0.placeholder = "위와 동일한 비밀번호를 입력해주세요"
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUI()
        bindViewModel()
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
            .bind { [weak self] in
                self?.viewModel.requestIdDuplicated()
            }
            .disposed(by: disposeBag)
        
        viewModel.isValidateIdButtonEnabled
            .bind(to: idValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateIdButtonEnabled
            .map { $0 ? .red : .gray }
            .bind(to: idValidateButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .map { $0 ? .red : .gray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
   
    @objc private func nextButtonTapped() {
        self.delegate?.didCompleteFirstStep()
    }

}
