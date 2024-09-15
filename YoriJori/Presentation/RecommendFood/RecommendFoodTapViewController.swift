//
//  MainViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import SnapKit
import RxSwift

class RecommendFoodTapViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let topBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemColor.yorijoriPink
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
//    private let userTasteLabel = UILabel().then {
//        $0.text = "요리조리님은,\n에너지 운동가"
//        $0.numberOfLines = 0
//        $0.font = DesignSystemFont.extraBold16
//        $0.textColor = DesignSystemColor.white
//        $0.textAlignment = .center
//        $0.asColor(targetString: "에너지 운동가", color: UIColor.init(hex: "#B92100"))
//    }
    
    private let nameLabel = UILabel().then {
        $0.text = "요리조리님은,"
        $0.font = DesignSystemFont.extraBold20
        $0.textColor = DesignSystemColor.gray100
    }
    
    private let typeLabel = UILabel().then {
        $0.font = UIFont.suit(.bold, size: 28)
        $0.text = "에너지 운동가"
        $0.textColor = UIColor.init(hex: "#B92100")
    }
    
    private let typeUnderLine = UIImageView().then {
        $0.image = UIImage(named: "type_underLine")
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "energe_character")
    }
    
//    private let userTasteLabel = UILabel().then {
//        $0.text = "요리조리님의 음식 취향은\n어떤 취향 일까요?"
//        $0.numberOfLines = 0
//        $0.font = DesignSystemFont.semibold18
//        $0.textColor = DesignSystemColor.white
//        $0.textAlignment = .center
//    }
    
//    private let foodTasteTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.yorijoriPink).then {
//        $0.text = "테스트 하러가기"
//    }
    
    private let reTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray600).then {
        $0.text = "테스트 다시하기"
        $0.semanticContentAttribute = .forceRightToLeft
        $0.setImage(UIImage(named: "return"), for: .normal)
    }
    
    private let grayView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let myGradientLabel = UILabel().then {
        $0.text = "내 식재료"
        $0.font = DesignSystemFont.subTitle2
        $0.textColor = DesignSystemColor.gray900
    }
    
//    private let registerView = FoodRegisterView()
    
    private lazy var myIngredientsView = UIImageView().then {
        $0.image = UIImage(named: "my_ingredients")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.moveToFoodRegister))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private let foodRecommendButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "음식 추천받기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.yorijoriPink
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setUI() {
        self.scrollView.backgroundColor = DesignSystemColor.white
        self.contentView.backgroundColor = DesignSystemColor.white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
//        [topBackgroundView, grayView, myGradientLabel, registerView, foodRecommendButton].forEach({self.view.addSubview($0)})
        [topBackgroundView, grayView, myGradientLabel, myIngredientsView, foodRecommendButton].forEach({self.contentView.addSubview($0)})
//        [profileImage, userTasteLabel, foodTasteTestButton].forEach({self.topBackgroundView.addSubview($0)})
        [nameLabel, typeLabel, typeUnderLine, profileImage, reTestButton].forEach({self.topBackgroundView.addSubview($0)})
        
        topBackgroundView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(411)
        })
        
        nameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        })
        
        typeLabel.snp.makeConstraints({
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        })
        
        typeUnderLine.snp.makeConstraints({
            $0.top.equalTo(self.typeLabel.snp.bottom).offset(7)
            $0.width.equalTo(180)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
        })
        
        profileImage.snp.makeConstraints({
            $0.top.equalTo(self.typeUnderLine.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(209)
            $0.height.equalTo(186)
        })
        
        reTestButton.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(137)
            $0.height.equalTo(40)
        })
        
//        profileImage.snp.makeConstraints({
//            $0.top.equalToSuperview().offset(64)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(209)
//            $0.height.equalTo(186)
//        })
//        
//        userTasteLabel.snp.makeConstraints({
//            $0.top.equalTo(self.profileImage.snp.bottom).offset(22)
//            $0.centerX.equalToSuperview()
//        })
        
//        foodTasteTestButton.snp.makeConstraints({
//            $0.top.equalTo(self.userTasteLabel.snp.bottom).offset(12)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(180)
//            $0.height.equalTo(42)
//        })
        
        grayView.snp.makeConstraints({
            $0.top.equalTo(self.topBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        myGradientLabel.snp.makeConstraints({
            $0.top.equalTo(self.grayView.snp.top).offset(28)
            $0.leading.equalToSuperview().offset(16)
        })
        
//        registerView.snp.makeConstraints({
//            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
//            $0.leading.trailing.equalToSuperview().inset(16)
//            $0.height.equalTo(190)
//        })
        myIngredientsView.snp.makeConstraints({
            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(295)
        })
        
//        foodRecommendButton.snp.makeConstraints({
//            $0.top.equalTo(self.registerView.snp.bottom).offset(16)
//            $0.leading.trailing.equalToSuperview().inset(16)
//            $0.height.equalTo(50)
//        })
        foodRecommendButton.snp.makeConstraints({
            $0.top.equalTo(self.myIngredientsView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-10)
        })
        
        self.scrollView.updateContentSize()
    }
    
    private func bind() {
//        foodTasteTestButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.moveToTasteTest()
//            })
//            .disposed(by: disposeBag)
        
        
        
//        registerView.isUserInteractionEnabled = true
//        registerView.registerButton.rx.tap
//            .subscribe (onNext: { [weak self] in
//                self?.moveToFoodRegister()
//            })
//            .disposed(by: disposeBag)
        
        foodRecommendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.moveToFoodRecommend()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToTasteTest() {
        let vc = FirstTasteTestViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    private func moveToFoodRegister() {
//        let vc = RegisterFoodViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @objc private func moveToFoodRegister() {
        let vc = RegisterFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToFoodRecommend() {
        let vc = RecommendFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
