//
//  HomeViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit
import SnapKit
import ARKit

class HomeViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "small_logo")
    }
    
    private let bottomSheetview = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.borderColor = DesignSystemColor.gray150.cgColor
        $0.layer.borderWidth = 1
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let recognizeDescLabel = UILabel().then {
        $0.text = "식재료를 인식해 보세요!"
        $0.font = DesignSystemFont.bold18
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let recognizeButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료 인식하기"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        sceneView.delegate = self
        setUI()
        
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
    
    private func setUI() {
        [logo, sceneView, bottomSheetview].forEach({self.view.addSubview($0)})
        [recognizeDescLabel, recognizeButton].forEach({self.bottomSheetview.addSubview($0)})
        
        logo.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(7)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(32)
        })
        
        sceneView.snp.makeConstraints({
            $0.top.equalTo(self.logo.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        bottomSheetview.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(137)
        })
        
        recognizeDescLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        })
        
        recognizeButton.snp.makeConstraints({
            $0.top.equalTo(self.recognizeDescLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }

}
