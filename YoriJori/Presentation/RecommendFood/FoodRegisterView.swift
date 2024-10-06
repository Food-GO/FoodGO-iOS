//
//  FoodRegisterView.swift
//  YoriJori
//
//  Created by 김강현 on 7/22/24.
//

import UIKit
import SnapKit
import RxSwift

class FoodRegisterView: UIView {
    
    var foodItems: [FoodList] = [] {
        didSet {
            isFoodListEmpty = foodItems.isEmpty
            collectionView.reloadData()
            updateUI()
        }
    }
    
    var isFoodListEmpty: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    private let notExistIngredientsLabel = UILabel().then {
        $0.text = "아직 등록된 식재료가 없어요"
        $0.textColor = DesignSystemColor.gray600
        $0.font = DesignSystemFont.subTitle2
    }
    
    let registerButton = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.yorijoriPink, borderColor: DesignSystemColor.yorijoriPink, selectedBorderColor: DesignSystemColor.yorijoriPink).then {
        $0.text = "식재료 등록하기 +"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 13
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(FoodItemCell.self, forCellWithReuseIdentifier: FoodItemCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [notExistIngredientsLabel, registerButton, collectionView].forEach { addSubview($0) }
        
        notExistIngredientsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(registerButton.snp.top).offset(-14)
        }
    }
    
    private func updateUI() {
        notExistIngredientsLabel.isHidden = !isFoodListEmpty
        collectionView.isHidden = isFoodListEmpty
    }
    
}

extension FoodRegisterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCell.identifier, for: indexPath) as? FoodItemCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: foodItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2 // 3열로 설정, 열 사이 간격 10
        return CGSize(width: width, height: 56) // 이미지 높이 + 텍스트 공간
    }
}
