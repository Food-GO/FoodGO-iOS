//
//  HomeRecognizeARViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/22/24.
//

import UIKit
import SnapKit
import ARKit
import RxSwift
import RxCocoa

class HomeRecognizeARViewController: UIViewController, ARSCNViewDelegate {
    
//    private let sceneView = ARSCNView()
    
    private let disposeBag = DisposeBag()
    
    let capturedImage = UIImageView()
    
    var detectedFoodName: [String] = []
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left")?.withTintColor(DesignSystemColor.white), for: .normal)
    }
    
    private let toggle = UISwitch().then {
        $0.tintColor = DesignSystemColor.white
        $0.onTintColor = DesignSystemColor.white
        $0.setOn(false, animated: false)
    }
    
    private let egg = CalorieCheckWithTextView(text: "달걀", risk: "soso")
    
    private let tomato = CalorieCheckWithTextView(text: "토마토", risk: "bad")
    
    private let greenOnion = CalorieCheckWithTextView(text: "대파", risk: "good")
    
    private let bottomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let resultButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "결과 보기"
    }
    
    private let reRecognizeButton = YorijoriFilledButton(bgColor: DesignSystemColor.gray150, textColor: DesignSystemColor.gray700).then {
        $0.text = "재인식"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
//        self.view.addSubview(sceneView)
        self.view.addSubview(capturedImage)
        
//        sceneView.delegate = self
//        let configuration = ARWorldTrackingConfiguration()
//        sceneView.session.run(configuration)
        
//        sceneView.snp.makeConstraints({
//            $0.edges.equalToSuperview()
//        })
        capturedImage.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
//        let configuration = ARWorldTrackingConfiguration()
//        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        sceneView.session.pause()
    }
    
    
    
    private func setUI() {
//        [backButton, toggle, egg, tomato, greenOnion, bottomButtonStackView].forEach({self.sceneView.addSubview($0)})
        [backButton, toggle, egg, tomato, greenOnion, bottomButtonStackView].forEach({self.capturedImage.addSubview($0)})
        [resultButton, reRecognizeButton].forEach({self.bottomButtonStackView.addArrangedSubview($0)})
        
        backButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(22)
        })
        
        toggle.snp.makeConstraints({
            $0.centerY.equalTo(self.backButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.equalTo(74)
            $0.height.equalTo(32)
        })
        
        egg.snp.makeConstraints({
            $0.top.equalTo(self.toggle.snp.bottom).offset(143)
            $0.leading.equalToSuperview().offset(180)
            $0.width.equalTo(104)
            $0.height.equalTo(48)
        })
        
        tomato.snp.makeConstraints({
            $0.top.equalTo(self.egg.snp.bottom).offset(218)
            $0.leading.equalToSuperview().offset(65)
            $0.width.equalTo(98)
            $0.height.equalTo(49)
        })
        
        greenOnion.snp.makeConstraints({
            $0.top.equalTo(self.tomato.snp.bottom).offset(56)
            $0.trailing.equalToSuperview().offset(-69)
            $0.width.equalTo(100)
            $0.height.equalTo(48)
        })
        
        bottomButtonStackView.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(50)
        })
        
        reRecognizeButton.snp.makeConstraints({
            $0.width.equalTo(77)
        })
    }
    
    private func bind() {
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.backButtonTapped()
            })
            .disposed(by: disposeBag)
        
        
        toggle.rx.isOn
            .subscribe(onNext: { [weak self] isOn in
                self?.toggle.thumbTintColor = isOn ? DesignSystemColor.yorijoriPink : DesignSystemColor.white
                
                self?.egg.riskImageView.isHidden = !isOn
                self?.tomato.riskImageView.isHidden = !isOn
                self?.greenOnion.riskImageView.isHidden = !isOn
            })
            .disposed(by: disposeBag)
        
        resultButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.moveToIngredientInfo()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func moveToIngredientInfo() {
        let ingredientVC = IngredientInfoViewController()
        ingredientVC.modalPresentationStyle = .overFullScreen
        
        guard let capturedImage = self.captureSceneCurrentImage() else { return }
        ingredientVC.captureImageView.image = capturedImage
        
        self.navigationController?.pushViewController(ingredientVC, animated: true)
    }
    
    private func captureSceneCurrentImage() -> UIImage? {
//        guard let currentFrame = self.sceneView.session.currentFrame else {
//            print("현재 프레임을 가져올 수 없습니다.")
//            return nil
//        }
//        
//        let image = CIImage(cvPixelBuffer: currentFrame.capturedImage)
//        let context = CIContext(options: nil)
//        guard let cgImage = context.createCGImage(image, from: image.extent) else {
//            print("CGImage를 생성할 수 없습니다.")
//            return nil
//        }
//        
//        let uiImage = UIImage(cgImage: cgImage)
//        let rotatedImage = rotateImage(uiImage, byDegrees: 90)
//        return rotatedImage
        return capturedImage.image
    }
    
    private func rotateImage(_ image: UIImage, byDegrees degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180
        let rotatedSize = CGRect(origin: .zero, size: image.size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2,
                                  width: image.size.width, height: image.size.height))
        }
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? image
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
