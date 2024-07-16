//
//  RegistUserDescViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol ThirdRegistViewControllerDelegate {
    func didCompleteThirdStep()
}

class ThirdRegistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var delegate: ThirdRegistViewControllerDelegate?
    private let viewModel = ThirdRegistViewModel()
    private var disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .red.withAlphaComponent(0.5)
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let progressBar = UISlider().then {
        $0.thumbTintColor = .clear
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.setValue(0.75, animated: false)
        $0.minimumTrackTintColor = .red.withAlphaComponent(0.5)
        $0.isUserInteractionEnabled = false
    }
    
    private let usageLabel = UILabel().then {
        $0.text = "용도"
        $0.textColor = DesignSystemColor.textColor
        $0.font = DesignSystemFont.semiBold14
    }
    
    private var usageCollectionView: UICollectionView!
    
    private let diseaseLabel = UILabel().then {
        $0.text = "유병 질환"
        $0.textColor = DesignSystemColor.textColor
        $0.font = DesignSystemFont.semiBold14
    }
    
    private var diseaseCollectionView: UICollectionView!
    
    private lazy var nextButton = UIButton().then {
        $0.backgroundColor = .blue.withAlphaComponent(0.5)
        $0.setTitle("다음", for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setScrollView()
        setCollectionView()
        setUI()
        bindViewModel()
    }
    
    private func setScrollView() {
        [scrollView, contentView].forEach({$0.backgroundColor = .white})
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
    }
    
    private func setCollectionView() {
        let usageCollectionlayout = UICollectionViewFlowLayout()
        usageCollectionlayout.minimumLineSpacing = 8
        usageCollectionlayout.minimumInteritemSpacing = 8
        usageCollectionlayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.usageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: usageCollectionlayout)
        self.usageCollectionView.delegate = self
        self.usageCollectionView.register(UsageCategoryCell.self, forCellWithReuseIdentifier: UsageCategoryCell.identifier)
        self.usageCollectionView.isScrollEnabled = false
        self.usageCollectionView.isUserInteractionEnabled = true
        
        let diseaseCollectionlayout = UICollectionViewFlowLayout()
        diseaseCollectionlayout.minimumLineSpacing = 8
        diseaseCollectionlayout.minimumInteritemSpacing = 8
        diseaseCollectionlayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.diseaseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: diseaseCollectionlayout)
        self.diseaseCollectionView.delegate = self
        self.diseaseCollectionView.register(DiseaseCategoryCell.self, forCellWithReuseIdentifier: DiseaseCategoryCell.identifier)
        self.diseaseCollectionView.isScrollEnabled = false
        self.diseaseCollectionView.isUserInteractionEnabled = true
    }
    
    private func setUI() {
        
        [progressBar, usageLabel, usageCollectionView, diseaseLabel, diseaseCollectionView, nextButton].forEach({self.contentView.addSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        usageLabel.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(15)
        })
        
        usageCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.usageLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-43)
            $0.height.equalTo(88)
        })
        
        diseaseLabel.snp.makeConstraints({
            $0.top.equalTo(self.usageCollectionView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(15)
        })
        
        diseaseCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.diseaseLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        })
        
        nextButton.snp.makeConstraints({
            $0.top.equalTo(self.diseaseCollectionView.snp.bottom).offset(300)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview().offset(-50)
        })
        
        self.scrollView.updateContentSize()
    }
    
    private func bindViewModel() {
        Observable.just(viewModel.usageCategories)
            .bind(to: usageCollectionView.rx.items(cellIdentifier: UsageCategoryCell.identifier, cellType: UsageCategoryCell.self)) { [weak self] index, text, cell in
                guard let self = self else {return}
                cell.button.rx.tap
                    .map { index }
                    .subscribe(onNext: { [weak self] index in
                        self?.viewModel.usageSelectedButtonIndex.accept(index)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                self.viewModel.usageSelectedButtonIndex
                    .map { $0 == index }
                    .subscribe(onNext: { isSelected in
                        cell.configure(text: text, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        Observable.just(viewModel.diseaseCategories)
            .bind(to: diseaseCollectionView.rx.items(cellIdentifier: DiseaseCategoryCell.identifier, cellType: DiseaseCategoryCell.self)) { [weak self] index, text, cell in
                guard let self = self else {return}
                cell.button.rx.tap
                    .map { index }
                    .subscribe(onNext: { [weak self] index in
                        self?.viewModel.diseaseSelectedButtonIndex.accept(index)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                self.viewModel.diseaseSelectedButtonIndex
                    .map { $0 == index }
                    .subscribe(onNext: { isSelected in
                        cell.configure(text: text, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.usageCollectionView {
            let text = viewModel.usageCategories[indexPath.item]
            let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: DesignSystemFont.medium12])
            let width = textSize.width + 24
            let height = textSize.height + 22
            return CGSize(width: width, height: height)
        } else {
            let text = viewModel.diseaseCategories[indexPath.item]
            let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: DesignSystemFont.medium12])
            let width = textSize.width + 24
            let height = textSize.height + 22
            return CGSize(width: width, height: height)
        }
        
    }
    
    @objc private func nextButtonTapped() {
        self.delegate?.didCompleteThirdStep()
    }
    
}

