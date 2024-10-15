//
//  MainViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import SnapKit
import RxSwift
import Alamofire

struct FoodResponse: Codable {
    let statusCode: String
    let message: String
    let content: [FoodList]
}

struct TasteTestResponse: Codable {
    let statusCode: String
    let message: String
    let content: TasteTestContent
}

struct FoodList: Codable {
    let ingredientId: Int
    let name: String
    let quantity: String
    let imageUrl: String?
}

struct TasteTestContent: Codable {
    let testType: String
    
    enum CodingKeys: String, CodingKey {
        case testType = "testType"
    }
}

enum TestType: String, Codable {
    case none = "NONE"
    case social = "SOCIAL"
    case energy = "ENERGY"
    case adventurous = "ADVENTUROUS"
    case healthy = "HEALTHY"
    case convenient = "CONVENIENT"
}

class RecommendFoodTapViewController: UIViewController {
    
    var testResult: TestType? {
        didSet {
            isTestResultEmpty = testResult == nil || testResult == .none
            updateUI()
        }
    }
    
    var isTestResultEmpty: Bool = true {
        didSet {
            updateUI()
        }
    }
    
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
        $0.isHidden = true
    }
    
    private let typeLabel = UILabel().then {
        $0.font = UIFont.suit(.bold, size: 28)
        $0.text = "에너지 운동가"
        $0.textColor = UIColor.init(hex: "#B92100")
        $0.isHidden = true
    }
    
    private let typeUnderLine = UIImageView().then {
        $0.image = UIImage(named: "type_underLine")
        $0.isHidden = true
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "energe_character")
    }
    
    private let userTasteLabel = UILabel().then {
        $0.text = "요리조리님의 음식 취향은\n어떤 취향 일까요?"
        $0.numberOfLines = 0
        $0.font = DesignSystemFont.semibold18
        $0.textColor = DesignSystemColor.white
        $0.textAlignment = .center
    }
    
    private let foodTasteTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.yorijoriPink).then {
        $0.text = "테스트 하러가기"
    }
    
    //    private let reTestButton = YorijoriFilledButton(bgColor: DesignSystemColor.gray100, textColor: DesignSystemColor.gray600).then {
    //        $0.text = "테스트 다시하기"
    //        $0.semanticContentAttribute = .forceRightToLeft
    //        $0.setImage(UIImage(named: "return"), for: .normal)
    //    }
    
    private let grayView = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let myGradientLabel = UILabel().then {
        $0.text = "내 식재료"
        $0.font = DesignSystemFont.subTitle2
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let registerView = FoodRegisterView()
    
    //    private lazy var myIngredientsView = UIImageView().then {
    //        $0.image = UIImage(named: "my_ingredients")
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.moveToFoodRegister))
    //        $0.isUserInteractionEnabled = true
    //        $0.addGestureRecognizer(tapGesture)
    //    }
    
    private let foodRecommendButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "음식 추천받기"
        $0.isHidden = true
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
        
        Task {
            do {
                let foodList = try await getFoodList()
                print("받은 음식 목록: \(foodList)")
                
                if foodList.isEmpty {
                    self.foodRecommendButton.isHidden = true
                } else {
                    self.registerView.foodItems = foodList
                    self.foodRecommendButton.isHidden = false
                }
            } catch {
                print("getFoodList 오류 발생: \(error)")
            }
        }
        
        Task {
            do {
                let testResult = try await getTestResult()
                print("테스트 결과: \(testResult)")
                self.testResult = testResult
            } catch {
                print("getTestResult 오류 발생: \(error)")
            }
        }
        
        print("테슽트 결과 여부 \(isTestResultEmpty)")
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
        //        [topBackgroundView, grayView, myGradientLabel, myIngredientsView, foodRecommendButton].forEach({self.contentView.addSubview($0)})
        [topBackgroundView, grayView, myGradientLabel, registerView, foodRecommendButton].forEach({self.contentView.addSubview($0)})
        [profileImage, userTasteLabel, nameLabel, typeLabel, typeUnderLine, foodTasteTestButton].forEach({self.topBackgroundView.addSubview($0)})
        //        [nameLabel, typeLabel, typeUnderLine, profileImage, reTestButton].forEach({self.topBackgroundView.addSubview($0)})
        
        topBackgroundView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(411)
        })
        
        //        reTestButton.snp.makeConstraints({
        //            $0.top.equalTo(self.profileImage.snp.bottom).offset(20)
        //            $0.centerX.equalToSuperview()
        //            $0.width.equalTo(137)
        //            $0.height.equalTo(40)
        //        })
        
        profileImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(64)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(209)
            $0.height.equalTo(186)
        })
        
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        })
        
        typeLabel.snp.makeConstraints({
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        })
        
        typeUnderLine.snp.makeConstraints({
            $0.top.equalTo(self.typeLabel.snp.bottom).offset(2)
            $0.width.equalTo(180)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
        })
        
        userTasteLabel.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        })
        
        foodTasteTestButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(42)
        })
        
        grayView.snp.makeConstraints({
            $0.top.equalTo(self.topBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        myGradientLabel.snp.makeConstraints({
            $0.top.equalTo(self.grayView.snp.top).offset(28)
            $0.leading.equalToSuperview().offset(16)
        })
        
        registerView.snp.makeConstraints({
            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(295)
            //            $0.bottom.equalToSuperview().offset(-50)
        })
        
        //        myIngredientsView.snp.makeConstraints({
        //            $0.top.equalTo(self.myGradientLabel.snp.bottom).offset(12)
        //            $0.leading.trailing.equalToSuperview().inset(16)
        //            $0.height.equalTo(295)
        //        })
        
        //        foodRecommendButton.snp.makeConstraints({
        //            $0.top.equalTo(self.registerView.snp.bottom).offset(16)
        //            $0.leading.trailing.equalToSuperview().inset(16)
        //            $0.height.equalTo(50)
        //        })
        
        foodRecommendButton.snp.makeConstraints({
            $0.top.equalTo(self.registerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-50)
        })
        
        self.scrollView.updateContentSize()
    }
    
    private func updateUI() {
        if let result = testResult {
            switch result {
            case .none:
//                typeLabel.text = "요리조리님의 음식 취향은\n어떤 취향 일까요?"
                return
            case .social:
                typeLabel.text = "사회적 미식가"
                
            case .energy:
                typeLabel.text = "에너지 운동가"
                
            case .adventurous:
                typeLabel.text = "모험심 가득한 미식가"
                
            case .healthy:
                typeLabel.text = "건강한 미식가"
                
            case .convenient:
                typeLabel.text = "간편 요리사"
            }
        }
        
        if isTestResultEmpty {
            [nameLabel, typeLabel, typeUnderLine].forEach({$0.isHidden = true})
            userTasteLabel.isHidden = false
        } else {
            [nameLabel, typeLabel, typeUnderLine].forEach({$0.isHidden = false})
            userTasteLabel.isHidden = true
        }
    }
    
    
    private func bind() {
        foodTasteTestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.moveToTasteTest()
            })
            .disposed(by: disposeBag)
        
        registerView.isUserInteractionEnabled = true
        registerView.registerButton.rx.tap
            .subscribe (onNext: { [weak self] in
                self?.moveToFoodRegister()
                
            })
            .disposed(by: disposeBag)
        
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
    
    private func moveToFoodRecommend() {
        let vc = RecommendFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getFoodList() async throws -> [FoodList] {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsManager.shared.accesstoken)"
        ]
        print("헤더 \(header)")
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.get(.cuisine, headers: header) { (result: Result<FoodResponse, NetworkError>) in
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
    
    private func getTestResult() async throws -> TestType {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsManager.shared.accesstoken)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.get(.test, headers: header) { (result: Result<TasteTestResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    print("결과값 \(response)")
                    if response.statusCode == "400" && response.content.testType == "NONE" {
                        continuation.resume(returning: .none)
                    } else {
                        // 여기서 다른 testType에 대한 처리를 추가할 수 있습니다.
                        continuation.resume(returning: TestType(rawValue: response.content.testType) ?? .none)
                    }
                case .failure(let error):
                    print("실패 \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @objc private func moveToFoodRegister() {
        let vc = RegisterFoodViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
