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
    private let viewModel: RecipeGuideViewModel
    private let disposeBag = DisposeBag()
    
    private let containerView = UIView().then {
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
    }
    
    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 24
    }
    
    private let headerLeftChevron = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left"), for: .normal)
    }
    
    private let headerTitle = UILabel().then {
        $0.font = DesignSystemFont.bold18
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let headerRightChevron = UIButton().then {
        $0.setImage(UIImage(named: "chevron_right"), for: .normal)
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
        $0.textAlignment = .center
    }
    
    init(viewModel: RecipeGuideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindButtons()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        [containerView, closeButton].forEach({self.view.addSubview($0)})
        
        containerView.snp.makeConstraints ({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(200)
        })
        
        closeButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-18)
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
            $0.bottom.equalToSuperview().offset(-20)
        })
        
        contentsLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        })
        
    }
    
    private func bindButtons() {
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
//                self?.dismiss(animated: true)
                self?.returnToHome()
            })
            .disposed(by: disposeBag)
        
        headerLeftChevron.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.moveToPreviousStep()
            })
            .disposed(by: disposeBag)
        
        headerRightChevron.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.moveToNextStep()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.currentStepIndex
            .map { [weak self] index in
                self?.viewModel.getStepTitle(for: index) ?? ""
            }
            .bind(to: headerTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.canMoveToNextStep
            .bind(to: headerRightChevron.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.canMoveToPreviousStep
            .bind(to: headerLeftChevron.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.currentStepIndex
            .map { [weak self] index -> String? in
                guard let self = self else { return nil }
                return index == 0 ? nil : self.viewModel.getCurrentStep()
            }
            .do(onNext: { [weak self] text in
                self?.updateContentsVisibility(text: text)
            })
            .bind(to: contentsLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func updateContentsVisibility(text: String?) {
        if let text = text, !text.isEmpty {
            contentsContainer.isHidden = false
            contentsLabel.text = text
        } else {
            contentsContainer.isHidden = true
            contentsLabel.text = nil
        }
    }
    
    private func returnToHome() {
        let tabVC = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabVC
            window.makeKeyAndVisible()
            sceneDelegate.window = window
            
        } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = tabVC
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
    }
}

