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

class IngredientsDetailInfoViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let tomatoView = IngredientsDetailInfoView(model: IngredientsDetailModel(
        foodImage: UIImage(named: "tomato")!,
        foodName: "토마토",
        foodAmount: "수량 | 2개",
        totalCalorie: "27 kcal",
        carbohydrates: "5.88g",
        nat: "8mg",
        protein: "1.32g",
        cholesterol: "0mg",
        fat: "0.3g",
        saturatedFat: "0.069g",
        sugars: "0g",
        transFats: "0g"
    ))
    
    private let eggView = IngredientsDetailInfoView(model: IngredientsDetailModel(
        foodImage: UIImage(named: "egg")!,
        foodName: "계란",
        foodAmount: "수량 | 4개",
        totalCalorie: "294 kcal",
        carbohydrates: "1.54g",
        nat: "280mg",
        protein: "25.16g",
        cholesterol: "846mg",
        fat: "19.88g",
        saturatedFat: "6.198g",
        sugars: "0g",
        transFats: "0g"
    ))
    
    private let greenOnionView = IngredientsDetailInfoView(model: IngredientsDetailModel(
        foodImage: UIImage(named: "greenOnion")!,
        foodName: "대파",
        foodAmount: "수량 | 1개",
        totalCalorie: "61 kcal",
        carbohydrates: "11.7g",
        nat: "31mg",
        protein: "3.42g",
        cholesterol: "0mg",
        fat: "0.72g",
        saturatedFat: "0.121g",
        sugars: "0g",
        transFats: "0g"
    ))
    
    private let reportButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "리포트 보러가기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        setUI()
        bind()
    }
    
    private func setupNavigationBar() {
        self.title = "식재료 상세정보"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        self.scrollView.backgroundColor = DesignSystemColor.gray150
        self.contentView.backgroundColor = DesignSystemColor.gray150
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        [tomatoView, eggView, greenOnionView, reportButton].forEach({self.contentView.addSubview($0)})
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        tomatoView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(260)
        })
        
        eggView.snp.makeConstraints({
            $0.top.equalTo(self.tomatoView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(260)
        })
        
        greenOnionView.snp.makeConstraints({
            $0.top.equalTo(self.eggView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(260)
        })
        
        reportButton.snp.makeConstraints({
            $0.top.equalTo(self.greenOnionView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-10)
        })
        
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
