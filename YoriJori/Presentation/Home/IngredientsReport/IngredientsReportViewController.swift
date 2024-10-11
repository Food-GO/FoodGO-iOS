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
import Alamofire

struct IngredientReportResponse: Codable {
    let statusCode: String
    let message: String
    let content: IngredientReport
}

struct IngredientReport: Codable {
    let lastWeekTotal: Float
    let thisWeekTotal: Float
    let lastWeekCarbs: Float
    let thisWeekCarbs: Float
    let lastWeekProteins: Float
    let thisWeekProteins: Float
    let lastWeekFats: Float
    let thisWeekFats: Float
    let lastWeekSugar: Float
    let thisWeekSugar: Float
    let lastWeekSodium: Float
    let thisWeekSodium: Float
    let lastWeekCholesterol: Float
    let thisWeekCholesterol: Float
    let lastWeekSaturatedFat: Float
    let thisWeekSaturatedFat: Float
    let lastWeekTransFat: Float
    let thisWeekTransFat: Float
}

class IngredientsReportViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let weeklyReport = WeeklyReportView()
    
    private lazy var chartView = IngredientsReportView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            do {
                let reportData = try await getIngredientsReport()
                await MainActor.run {
                    self.updateViews(with: reportData)
                }
            } catch {
                print("Error fetching ingredients report: \(error)")
                // 여기에 에러 처리 로직을 추가할 수 있습니다. 예: 알림 표시
            }
        }
    }
    
    private func updateViews(with report: IngredientReport) {
        // WeeklyReportView 업데이트
        weeklyReport.update(lastWeekTotal: report.lastWeekTotal,
                            thisWeekTotal: report.thisWeekTotal)
        
        // IngredientsReportView 업데이트
        chartView.update(with: report)
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
        
        [weeklyReport, chartView, recommendFoodButton].forEach({self.contentView.addSubview($0)})
        
        weeklyReport.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(242)
        })
        
        chartView.snp.makeConstraints({
            $0.top.equalTo(self.weeklyReport.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(600)
        })
        
        recommendFoodButton.snp.makeConstraints({
            $0.top.equalTo(self.chartView.snp.bottom).offset(16)
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
    
    private func getIngredientsReport() async throws -> IngredientReport {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsManager.shared.accesstoken)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.get(.report, headers: header) { (result: Result<IngredientReportResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    print("결과값 \(response)")
                    continuation.resume(returning: response.content)
                case .failure(let error):
                    print("실패 \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
