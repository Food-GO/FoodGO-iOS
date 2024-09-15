//
//  LastRegisterViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class LastRegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let progressBar = UIView().then {
        $0.backgroundColor = DesignSystemColor.yorijoriPink
        $0.layer.cornerRadius = 2
    }
    
    private let doneImage = UIImageView().then {
        $0.image = UIImage(named: "register_done")
    }
    
    private let welcomeLabel = UILabel().then {
        $0.text = "요리조리님,\n요리조리에 오신 걸 환영해요!"
        $0.textColor = DesignSystemColor.gray900
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = DesignSystemFont.bold20
    }
    
    private let startButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "시작하기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        setUI()
        bind()
    }
    
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        [progressBar, doneImage, welcomeLabel, startButton].forEach({self.view.addSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(4)
        })
        
        doneImage.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(106)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(322)
        })
        
        welcomeLabel.snp.makeConstraints({
            $0.top.equalTo(self.doneImage.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        })
        
        startButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    private func bind() {
        startButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
