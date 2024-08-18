//
//  TutorialRecognizeFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ARKit

class TutorialRecognizeFoodViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    
    private let overlayView = UIView()
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
    }
    
    private let tutorialLabel = UILabel().then {
        $0.text = "카메라가 식재료를\n향하게 하세요"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = DesignSystemFont.medium20
        $0.textColor = DesignSystemColor.white
    }
    
    private let tutorialImage = UIImageView().then {
        $0.image = UIImage(named: "tutorial_food")
    }
    
    private let recognizingFoodButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료를 인식 중이에요.."
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setARView()
        setupUI()
        bindButtons()
    }
    
    private func setARView() {
        self.view.addSubview(sceneView)
        sceneView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        sceneView.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func setupUI() {
        self.view.addSubview(overlayView)
        self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.overlayView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [closeButton, tutorialLabel, tutorialImage, recognizingFoodButton].forEach({self.overlayView.addSubview($0)})
        
        self.closeButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(28)
        })
        
        self.tutorialLabel.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(94)
            $0.centerX.equalToSuperview()
        })
        
        self.tutorialImage.snp.makeConstraints({
            $0.top.equalTo(self.tutorialLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(107)
            $0.height.equalTo(218)
        })
        
        recognizingFoodButton.snp.makeConstraints({
            $0.top.equalTo(self.tutorialImage.snp.bottom).offset(71)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(197)
            $0.height.equalTo(48)
        })
        
    }
    
    private func bindButtons() {
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        recognizingFoodButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.showRecognizeFoodView()
            })
            .disposed(by: disposeBag)
    }
    
    private func showRecognizeFoodView() {
        let recognizeFoodVC = RecognizeFoodARViewController()
        recognizeFoodVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(recognizeFoodVC, animated: true)
    }
}

