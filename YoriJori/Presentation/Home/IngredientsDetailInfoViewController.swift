//
//  IngredientsDetailInfoViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

class IngredientsDetailInfoViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var ingredientsData: [Ingredients] = []
    var capturedImage: UIImage?
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private var ingredientViews: [IngredientsDetailInfoView] = []
    
    private let reportButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "리포트 보러가기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        createIngredientViews()
        setUI()
        bind()
    }
    
    private func setupNavigationBar() {
        self.title = "식재료 상세정보"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func createIngredientViews() {
        guard let capturedImage = self.capturedImage else { return }
        
        ingredientViews = ingredientsData.map { ingredient in
            let model = IngredientsDetailModel(
                foodImage: capturedImage,
                foodName: ingredient.descKor.components(separatedBy: ",").first ?? "",
                foodAmount: "수량 | 1개", // 실제 수량 정보가 있다면 여기에 추가
                totalCalorie: "\(ingredient.kcal) kcal",
                carbohydrates: "\(ingredient.carbohydrate)g",
                nat: "\(ingredient.sodium)mg",
                protein: "\(ingredient.protein)g",
                cholesterol: "\(ingredient.cholesterol)mg",
                fat: "\(ingredient.fat)g",
                saturatedFat: "\(ingredient.fattyAcids)g",
                sugars: "\(ingredient.sugar)g",
                transFats: "\(ingredient.transFat)g"
            )
            return IngredientsDetailInfoView(model: model)
        }
    }
    
    private func setUI() {
        self.scrollView.backgroundColor = DesignSystemColor.gray150
        self.contentView.backgroundColor = DesignSystemColor.gray150
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        //        [tomatoView, eggView, greenOnionView, reportButton].forEach({self.contentView.addSubview($0)})
        ingredientViews.forEach { self.contentView.addSubview($0) }
        self.contentView.addSubview(reportButton)
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        var previousView: UIView?
        
        for (index, view) in ingredientViews.enumerated() {
            view.snp.makeConstraints {
                if let previousView = previousView {
                    $0.top.equalTo(previousView.snp.bottom).offset(12)
                } else {
                    $0.top.equalToSuperview().offset(16)
                }
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.height.equalTo(260)
            }
            previousView = view
        }
        
        reportButton.snp.makeConstraints {
            $0.top.equalTo(previousView?.snp.bottom ?? contentView.snp.top).offset(8)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        self.scrollView.updateContentSize()
    }
    
    private func bind() {
        reportButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.moveToReport()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToReport() {
        let reportVC = IngredientsReportViewController()
        reportVC.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
