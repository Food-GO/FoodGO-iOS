//
//  ReportViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa

class ReportViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var weeklyDietItems: [(mealTime: String, desc: String)] = [
        (mealTime: "점심", desc: "잡곡밥 1/2공기, 김치 약간,\n닭가슴살 샐러드(드레싱은 오일&식초 기반)"),
        (mealTime: "저녁", desc: "잡곡밥 1/2공기, 김치 약간,\n닭가슴살 샐러드(드레싱은 오일&식초 기반")
    ]
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var calendar : FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.scope = .week
        calendar.delegate = self
        calendar.dataSource = self
        
        //        calendar.weekdayHeight // 높이 설정
        calendar.appearance.weekdayFont = DesignSystemFont.medium14 // 폰트 설정
        calendar.appearance.weekdayTextColor = DesignSystemColor.gray600 // 텍스트 컬러 설정
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 2
        calendar.appearance.titleFont = DesignSystemFont.semibold16 // 일(1,2,3...) 폰트 설정
        calendar.appearance.titleDefaultColor = DesignSystemColor.gray800 // 선택되지 않은 날의 기본 컬러 설정
        calendar.appearance.titleSelectionColor = DesignSystemColor.yorijoriPink // 선택된 날의 컬러 설정
        calendar.appearance.titleTodayColor = DesignSystemColor.yorijoriGreen // 금일 컬러 설정
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.headerTitleFont = DesignSystemFont.semibold18
        calendar.appearance.headerTitleColor = DesignSystemColor.gray900
        return calendar
    }()
    
    private let whiteView = UIView().then {
        $0.backgroundColor = DesignSystemColor.white
    }
    
    private let emptyRecordView = EmptyFoodRecordView()
    
    private let weeklyDietGuideLabel = UILabel().then {
        $0.text = "이번주 식단 가이드"
        $0.font = DesignSystemFont.bold16
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let weeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WeeklyDietGuideCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyDietGuideCollectionViewCell.identifier)
        return cv
    }()
    
    private let weeklyReportLabel = UILabel().then {
        $0.text = "주간 리포트"
        $0.font = DesignSystemFont.bold16
        $0.textColor = DesignSystemColor.gray900
    }
    
    private lazy var chartView = WeeklyReportChartView().then {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveTodetailReport))
        $0.addGestureRecognizer(gesture)
        $0.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.gray150
        self.navigationController?.navigationBar.isHidden = true
        setCalendar()
        setUI()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToFoodRegister))
        self.emptyRecordView.addGestureRecognizer(gesture)
        self.emptyRecordView.isUserInteractionEnabled = true
    }
    
    private func setCalendar() {
        
    }
    
    
    private func setUI() {
        self.scrollView.backgroundColor = DesignSystemColor.gray150
        self.contentView.backgroundColor = DesignSystemColor.gray150
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        [calendar, whiteView].forEach({self.contentView.addSubview($0)})
        [emptyRecordView, weeklyDietGuideLabel, weeklyCollectionView, weeklyReportLabel, chartView].forEach({self.whiteView.addSubview($0)})
        
        weeklyCollectionView.dataSource = self
        weeklyCollectionView.delegate = self
        
        calendar.snp.makeConstraints({
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(150)
        })
        
        whiteView.snp.makeConstraints({
            $0.top.equalTo(self.calendar.snp.top).offset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(800)
            $0.bottom.equalToSuperview().offset(-10)
        })
        
        emptyRecordView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(190)
        })
        
        weeklyDietGuideLabel.snp.makeConstraints({
            $0.top.equalTo(self.emptyRecordView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(18)
        })
        
        weeklyCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.weeklyDietGuideLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        })
        
        weeklyReportLabel.snp.makeConstraints({
            $0.top.equalTo(self.weeklyCollectionView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(18)
        })
        
        chartView.snp.makeConstraints({
            $0.top.equalTo(self.weeklyReportLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(394)
        })
        
        self.scrollView.updateContentSize()
    }
    
    @objc private func moveTodetailReport() {
        let weeklyReportVC = WeeklyReportViewController()
        weeklyReportVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(weeklyReportVC, animated: true)
    }
    
    @objc private func moveToFoodRegister() {
        let vc = ManualAddFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ReportViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}

extension ReportViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeklyDietItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyDietGuideCollectionViewCell.identifier, for: indexPath) as? WeeklyDietGuideCollectionViewCell else {
            fatalError("Failed to dequeue CustomCollectionViewCell")
        }
        
        let item = weeklyDietItems[indexPath.item]
        cell.configure(mealTime: item.mealTime, desc: item.desc)
        return cell
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 277, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
