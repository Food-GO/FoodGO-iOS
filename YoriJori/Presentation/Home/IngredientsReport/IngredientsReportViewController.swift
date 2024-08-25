//
//  IngredientsReportViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class IngredientsReportViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let weeklyReport = WeeklyReportView()
    
    private let nutritionReportLabel = UILabel().then {
        $0.text = "영양정보 리포트"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private let secondWeekly = UIImageView().then {
        $0.image = UIImage(named: "weekly_second")
    }
    
    private let thirdWeekly = UIImageView().then {
        $0.image = UIImage(named: "weekly_third")
    }
    
    private let nutritionReport = UIImageView().then {
        $0.image = UIImage(named: "nutrition_report")
    }
    
    private let recommendFoodButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "음식 추천 받기"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.white
        setupNavigationBar()
        setUI()
        bind()
    }
    
    private func setupNavigationBar() {
        self.title = "식재료 리포트"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
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
        
        [weeklyReport, nutritionReportLabel, secondWeekly, thirdWeekly, nutritionReport, recommendFoodButton].forEach({self.contentView.addSubview($0)})
        
        weeklyReport.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(242)
        })
        
        nutritionReportLabel.snp.makeConstraints({
            $0.top.equalTo(self.weeklyReport.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
        })
        
        thirdWeekly.snp.makeConstraints({
            $0.centerY.equalTo(self.nutritionReportLabel)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.equalTo(61)
            $0.height.equalTo(18)
        })
        
        secondWeekly.snp.makeConstraints({
            $0.centerY.equalTo(self.nutritionReportLabel)
            $0.trailing.equalTo(self.thirdWeekly.snp.leading).offset(-8)
            $0.width.equalTo(61)
            $0.height.equalTo(18)
        })
        
        nutritionReport.snp.makeConstraints({
            $0.top.equalTo(self.secondWeekly.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(416)
        })
        
        recommendFoodButton.snp.makeConstraints({
            $0.top.equalTo(self.nutritionReport.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-10)
        })
        
        self.scrollView.updateContentSize()
    }
    
    private func bind() {
        recommendFoodButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.moveToRecommendFood()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToRecommendFood() {
        let recommendFoodVC = RecommendFoodViewController()
        recommendFoodVC.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.pushViewController(recommendFoodVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
