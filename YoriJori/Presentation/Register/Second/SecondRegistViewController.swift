//
//  RegistNicknameViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SecondRegistViewController: UIViewController {

    private let viewModel = SecondRegistViewModel()
    private var disposeBag = DisposeBag()
    
    private let progressBar = UISlider().then {
        $0.thumbTintColor = .clear
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.setValue(0.5, animated: false)
        $0.minimumTrackTintColor = DesignSystemColor.yorijoriPink
        $0.isUserInteractionEnabled = false
    }
    
    private let profileImageLabel = UILabel().then {
        $0.text = "프로필사진"
    }
    
    private let addProfileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "profileImage"), for: .normal)
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "아이디"
    }
    
    private let nicknameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let nicknameTextField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemColor.gray400
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
    }
    
    private let nicknameValidateButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.backgroundColor = .red.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemColor.gray400
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
        [progressBar, profileImageLabel, addProfileImageButton, nicknameLabel, nicknameStackView, nextButton].forEach({self.view.addSubview($0)})
        [nicknameTextField, nicknameValidateButton].forEach({self.nicknameStackView.addArrangedSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        profileImageLabel.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(15)
        })
        
        addProfileImageButton.snp.makeConstraints({
            $0.top.equalTo(self.profileImageLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(84)
        })
        
        nicknameLabel.snp.makeConstraints({
            $0.top.equalTo(self.addProfileImageButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
        })
        
        nicknameTextField.snp.makeConstraints({
            $0.width.equalTo(256)
            $0.height.equalTo(50)
        })
        
        nicknameValidateButton.snp.makeConstraints({
            $0.height.equalTo(50)
        })
        
        nicknameStackView.snp.makeConstraints({
            $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(6)
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
        nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nicknameRelay)
            .disposed(by: disposeBag)
        
        nicknameValidateButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.requestNicknameDuplicated()
            }
            .disposed(by: disposeBag)
        
        viewModel.isValidateButtonEnabled
            .bind(to: nicknameValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateButtonEnabled
            .map { $0 ? DesignSystemColor.yorijoriPink : DesignSystemColor.gray400 }
            .bind(to: nicknameValidateButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidateNextButtonEnabled
            .map { $0 ? DesignSystemColor.yorijoriPink : DesignSystemColor.gray400 }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }

    @objc private func nextButtonTapped() {
        let nextVC = ThirdRegistViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
