//
//  LoginViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
    }
    
    private let passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
    }
    
    private var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .red.withAlphaComponent(0.5)
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
    }
    
    private lazy var registerLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black
        let gesture = UITapGestureRecognizer(target: self, action: #selector(registerDidTap))
        $0.addGestureRecognizer(gesture)
        $0.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        [idTextField, passwordTextField, loginButton, registerLabel].forEach({self.view.addSubview($0)})
        
        idTextField.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        passwordTextField.snp.makeConstraints({
            $0.top.equalTo(self.idTextField.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        loginButton.snp.makeConstraints({
            $0.top.equalTo(self.passwordTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
        })
        
        registerLabel.snp.makeConstraints({
            $0.top.equalTo(self.loginButton.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().offset(-15)
        })
    }
    
    private func bindViewModel() {
        loginViewModel.isLoginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel.isLoginButtonEnabled
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginViewModel.loginResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    print("로그인 성공")
                    self?.loginSucceed()
                case .failure(let errorMessage):
                    print("로그인 실패: \(errorMessage)")
                    self?.showLoginFailedAlert()
                }
            })
            .disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .bind(to: loginViewModel.idRelay)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: loginViewModel.passwordRelay)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { [weak self] in
                self?.loginViewModel.requestLogin()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func showLoginFailedAlert() {
        print("로그인 실패")
    }
    

    @objc private func loginSucceed() {
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true)
    }
    
    @objc private func registerDidTap() {
        let firstVC = FirstRegistViewController()
        firstVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(firstVC, animated: true)
    }

}
