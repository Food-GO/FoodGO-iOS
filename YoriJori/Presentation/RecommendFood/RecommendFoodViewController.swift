//
//  RecommendFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/17/24.
//

import UIKit
import SnapKit
import ARKit

class RecommendFoodViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    
    private let foodImageView = UIImageView().then {
        $0.image = UIImage(named: "tomato_food_AR")
    }
    
    private let recipeContainer = UIView().then {
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.cornerRadius = 8
    }
    
    private let foodNameLabel = UILabel().then {
        $0.text = "토마토달걀볶음"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.semibold18
    }
    
    private let foodDescription = UILabel().then {
        $0.text = "바쁜 아침에 간단하게 먹을 수 있는 메뉴로 자극적이지 않고 간편하게 즐길 수 있는 토마토 달걀 볶음"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.regular14
        $0.numberOfLines = 0
    }
    
    private let ingredientsLabel = UILabel().then {
        $0.text = "[재료]"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.medium14
    }
    
    private let ingredientDescription = UILabel().then {
        $0.text = "토마토 250g, 달걀 4개, 식용유(스크램블용) 1/4컵(30g), 대파 1/2컵 (40g), 식용유(파 기름용) 1/4컵(30g), 진간장 1큰술(10g), 굴소스 1큰술(10g), 꽃소금 적당량, 후춧가루 적당량, 참기름 1/2큰술(3g)"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.regular14
        $0.numberOfLines = 0
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 8
    }
    
    private lazy var ARRecipeButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "AR 조리법 보러가기"
        $0.addTarget(self, action: #selector(showARRecipe), for: .touchUpInside)
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var youtubeButton = YorijoriFilledButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray900).then {
        $0.text = "유튜브"
        $0.addTarget(self, action: #selector(moveToYoutube), for: .touchUpInside)
        $0.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
        
        self.view.addSubview(sceneView)
        sceneView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        sceneView.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func setupNavigationBar() {
        self.title = "음식 추천"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        [foodImageView, recipeContainer, buttonStackView].forEach({self.sceneView.addSubview($0)})
        [foodNameLabel, foodDescription, ingredientsLabel, ingredientDescription].forEach({self.recipeContainer.addSubview($0)})
        [ARRecipeButton, youtubeButton].forEach({self.buttonStackView.addArrangedSubview($0)})
        
        foodImageView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(69)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(262)
        })
        
        youtubeButton.snp.makeConstraints({
            $0.width.equalTo(77)
        })
        
        buttonStackView.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
        
        recipeContainer.snp.makeConstraints({
            $0.bottom.equalTo(self.buttonStackView.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(249)
        })
        
        foodNameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        })
        
        foodDescription.snp.makeConstraints({
            $0.top.equalTo(self.foodNameLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(14)
        })
        
        ingredientsLabel.snp.makeConstraints({
            $0.top.equalTo(self.foodDescription.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        })
        
        ingredientDescription.snp.makeConstraints({
            $0.top.equalTo(self.ingredientsLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(14)
        })
    }
    
    @objc private func moveToYoutube() {
        if let url = URL(string: "https://www.youtube.com/results?search_query=%ED%86%A0%EB%A7%88%ED%86%A0%EB%8B%AC%EA%B1%80%EB%B3%B6%EC%9D%8C") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc private func showARRecipe() {
        let recipeVC = TutorialRecognizeFoodViewController()
        recipeVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(recipeVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
