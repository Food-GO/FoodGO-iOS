//
//  IngredientInfoViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class IngredientInfoViewController: UIViewController {
    
    var recognizedObjects: [(identifier: String, boundingBox: CGRect)] = []
    private var calorieInfoViews: [CalorieInfoView] = []
    private var ingredientsData: [Ingredients] = []
    
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left")?.withTintColor(DesignSystemColor.gray900), for: .normal)
    }
    
    var captureImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    
    //    private let eggInfoView = CalorieInfoView(foodName: "달걀")
    
    //    private let tomatoInfoView = CalorieInfoView(foodName: "토마토")
    
    //    private let greenOnionView = CalorieInfoView(foodName: "대파")
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let registerIngredientsButton = YorijoriFilledButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray800).then {
        $0.layer.borderColor = DesignSystemColor.gray150.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.text = "식재료 등록하기"
    }
    
    private let showDetailButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "상세정보"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        updateBoundingBoxes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBoundingBoxes()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUI() {
        [captureImageView, bottomStackView].forEach({self.view.addSubview($0)})
        //        [eggInfoView, tomatoInfoView, greenOnionView].forEach({self.captureImageView.addSubview($0)})
        [registerIngredientsButton, showDetailButton].forEach({self.bottomStackView.addArrangedSubview($0)})
        
        captureImageView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(641)
        })
        
        //        eggInfoView.snp.makeConstraints({
        //            $0.top.equalToSuperview().offset(41)
        //            $0.trailing.equalToSuperview().offset(-48)
        //            $0.width.equalTo(151)
        //            $0.height.equalTo(176)
        //        })
        //
        //        tomatoInfoView.snp.makeConstraints({
        //            $0.top.equalTo(self.eggInfoView.snp.bottom).offset(57)
        //            $0.leading.equalToSuperview().offset(21)
        //            $0.width.equalTo(151)
        //            $0.height.equalTo(179)
        //        })
        //
        //        greenOnionView.snp.makeConstraints({
        //            $0.top.equalTo(self.eggInfoView.snp.bottom).offset(203)
        //            $0.trailing.equalToSuperview().offset(-21)
        //            $0.width.equalTo(151)
        //            $0.height.equalTo(176)
        //        })
        
        bottomStackView.snp.makeConstraints({
            $0.top.equalTo(self.captureImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
        
    }
    
    private func bind() {
        registerIngredientsButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.showToast("등록되었습니다", withDuration: 2, delay: 1.5)
            })
            .disposed(by: disposeBag)
        
        showDetailButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.moveToDetailView()
            })
            .disposed(by: disposeBag)
    }
    
    private func showToast(_ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = DesignSystemFont.semibold12
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds  =  true
        
        self.captureImageView.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-17)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(34)
        })
        
        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func updateBoundingBoxes() {
        // 동일한 identifier를 가진 객체들 중 하나만 유지
        let uniqueObjects = Dictionary(grouping: recognizedObjects, by: { $0.identifier })
            .mapValues { $0.first! }
            .values
            .sorted { $0.identifier < $1.identifier }
        
        // 기존의 뷰들을 제거
        calorieInfoViews.forEach { $0.removeFromSuperview() }
        calorieInfoViews.removeAll()
        
        guard let image = captureImageView.image else { return }
        
        let imageSize = image.size
        let viewSize = captureImageView.bounds.size
        
        // 이미지의 aspect ratio를 유지하면서 뷰에 맞는 크기 계산
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        let scaledImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        // 이미지가 뷰 내에서 중앙에 위치하도록 오프셋 계산
        let xOffset = (viewSize.width - scaledImageSize.width) / 2
        let yOffset = (viewSize.height - scaledImageSize.height) / 2
        
        for object in uniqueObjects {
            let boxView = CalorieInfoView(foodName: "\(object.identifier)")
            
            print("\(object.identifier): x: \(object.boundingBox.origin.x * scale + xOffset), y: \(object.boundingBox.origin.y * scale + yOffset), width: \(object.boundingBox.width * scale), height: \(object.boundingBox.height * scale)")
            
            // 원본 바운딩 박스의 중심점 계산
            let centerX = object.boundingBox.midX * scale + xOffset
            let centerY = object.boundingBox.midY * scale + yOffset
            
            // CalorieInfoView의 크기
            let boxWidth: CGFloat = 151
            let boxHeight: CGFloat = 176
            
            // 화면 경계를 벗어나지 않도록 조정
            let minX = max(0, centerX - boxWidth / 2)
            let minY = max(0, centerY - boxHeight / 2)
            let maxX = min(viewSize.width - boxWidth, minX)
            let maxY = min(viewSize.height - boxHeight, minY)
            
            captureImageView.addSubview(boxView)
            calorieInfoViews.append(boxView)
            
            boxView.snp.makeConstraints { make in
                make.width.equalTo(boxWidth)
                make.height.equalTo(boxHeight)
                make.left.equalTo(maxX)
                make.top.equalTo(maxY)
            }
        }
        
        Task {
            await fetchAllIngredientsData()
        }
    }
    
    
    private func fetchAllIngredientsData() async {
        var allIngredients: [Ingredients] = []
        for view in calorieInfoViews {
            do {
                if let ingredients = try await view.fetchIngredientsAndUpdateUI() {
                    allIngredients.append(ingredients)
                }
            } catch {
                print("Error fetching ingredients for view: \(error)")
                // 에러 처리
            }
        }
        self.ingredientsData = allIngredients
        print("인식된 재료들 \(allIngredients)")
    }
    
    private func moveToDetailView() {
        let detailVC = IngredientsDetailInfoViewController()
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.ingredientsData = self.ingredientsData
        detailVC.capturedImage = self.captureImageView.image
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
