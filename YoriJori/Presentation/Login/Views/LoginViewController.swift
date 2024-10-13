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

class LoginViewController: BaseViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let homeLogo = UIImageView().then {
        $0.image = UIImage(named: "yorijori_logo")
    }
    
    private let serviceDescLabel = UILabel().then {
        $0.text = "내 취향과 식재료에\n딱 맞춘 요리 레시피"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = DesignSystemColor.yorijoriPink
        $0.font = DesignSystemFont.semibold22
    }
    
    private let idTextField = YorijoriTextField().then {
        $0.placeholder = "아이디"
    }
    
    private let passwordTextField = YorijoriTextField().then {
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
    }
    
    private var loginButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.setTitle("로그인", for: .normal)
        $0.isEnabled = false
    }
    
    private lazy var registerLabel = UILabel().then {
        $0.text = "계정이 없으신가요? 빠르게 가입하기"
        $0.textColor = DesignSystemColor.gray700
        $0.font = DesignSystemFont.medium14
        let gesture = UITapGestureRecognizer(target: self, action: #selector(registerDidTap))
        $0.addGestureRecognizer(gesture)
        $0.asColor(targetString: "빠르게 가입하기", color: DesignSystemColor.yorijoriGreen)
        $0.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        [homeLogo, serviceDescLabel, idTextField, passwordTextField, loginButton, registerLabel].forEach({self.view.addSubview($0)})
        
        homeLogo.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(117)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        })
        
        serviceDescLabel.snp.makeConstraints({
            $0.top.equalTo(self.homeLogo.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        })
        
        idTextField.snp.makeConstraints({
            $0.top.equalTo(self.serviceDescLabel.snp.bottom).offset(44)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(46)
        })
        
        passwordTextField.snp.makeConstraints({
            $0.top.equalTo(self.idTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(46)
        })
        
        loginButton.snp.makeConstraints({
            $0.top.equalTo(self.passwordTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        })
        
        registerLabel.snp.makeConstraints({
            $0.top.equalTo(self.loginButton.snp.bottom).offset(73)
            $0.centerX.equalToSuperview()
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
                    self?.loginSucceed()
                case .failure(let errorMessage):
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
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "로그인 실패", message: "아이디 또는 비밀번호가 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = windowScene.windows.first?.rootViewController {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func loginSucceed() {
        let mainVC = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
            sceneDelegate.window = window
            
        } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
    }
    
    @objc private func registerDidTap() {
        let idPasswordVC = IDPasswordViewController()
        idPasswordVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(idPasswordVC, animated: true)
    }
}
