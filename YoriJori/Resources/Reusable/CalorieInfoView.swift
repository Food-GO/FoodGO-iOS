//
//  CalorieInfoView.swift
//  YoriJori
//
//  Created by 김강현 on 8/23/24.
//

import UIKit
import SnapKit
import Alamofire

struct IngredientsResponse: Decodable {
    let statusCode: String
    let message: String
    let content: Ingredients
}

struct Ingredients: Codable {
    let descKor: String
    let groupName: String
    let kcal: String
    let carbohydrate: String
    let protein: String
    let fat: String
    let sugar: String
    let sodium: String
    let cholesterol: String
    let fattyAcids: String
    let transFat: String
    
    enum CodingKeys: String, CodingKey {
        case descKor = "DESC_KOR"
        case groupName = "GROUP_NAME"
        case kcal = "NUTR_CONT1"
        case carbohydrate = "NUTR_CONT2"
        case protein = "NUTR_CONT3"
        case fat = "NUTR_CONT4"
        case sugar = "NUTR_CONT5"
        case sodium = "NUTR_CONT6"
        case cholesterol = "NUTR_CONT7"
        case fattyAcids = "NUTR_CONT8"
        case transFat = "NUTR_CONT9"
    }
}

class CalorieInfoView: UIView {
    
    //    private var riskCategory = ""
    
    //    private let riskImageView = UIImageView()
    
    private var ingredients: Ingredients?
    
    private let foodNameLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    init(foodName: String) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemColor.white.withAlphaComponent(0.8)
        
        //        self.riskCategory = riskCategory
        self.foodNameLabel.text = foodName
        
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        //        [riskImageView, foodNameLabel, totalCalorieStackView, proteinStackView, calciumStackView, fatStackView].forEach({self.addSubview($0)})
//        [foodNameLabel, totalCalorieStackView, proteinStackView, calciumStackView, fatStackView].forEach({self.addSubview($0)})
        [foodNameLabel].forEach({self.addSubview($0)})
        
        //        switch riskCategory {
        //        case "good":
        //            riskImageView.image = UIImage(named: "risk_good")
        //            riskImageView.snp.makeConstraints({
        //                $0.top.equalToSuperview().offset(12)
        //                $0.centerX.equalToSuperview()
        //                $0.width.height.equalTo(22)
        //            })
        //        case "soso":
        //            riskImageView.image = UIImage(named: "risk_soso")
        //            riskImageView.snp.makeConstraints({
        //                $0.top.equalToSuperview().offset(12)
        //                $0.centerX.equalToSuperview()
        //                $0.width.equalTo(26)
        //                $0.height.equalTo(22)
        //            })
        //        case "bad":
        //            riskImageView.image = UIImage(named: "risk_bad")
        //            riskImageView.snp.makeConstraints({
        //                $0.top.equalToSuperview().offset(12)
        //                $0.centerX.equalToSuperview()
        //                $0.width.equalTo(6)
        //                $0.height.equalTo(26)
        //            })
        //        default:
        //            return
        //        }
        
        foodNameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        })
        
        
    }
    
    func fetchIngredientsAndUpdateUI() async throws -> Ingredients? {
        do {
            let ingredients = try await getIngredients()
            await MainActor.run {
                if let ingredients = ingredients {
                    self.ingredients = ingredients
                    self.updateUI()
                }
            }
            return ingredients
        } catch {
            print("Error fetching ingredients: \(error)")
            // 에러 처리
            throw error
        }
    }
    
    private func updateUI() {
        if let ingredients = self.ingredients {
            
            let totalCalorieStackView = CalorieInfoStackView(title: "총칼로리", amountText: "\(ingredients.kcal)")
            let proteinStackView = CalorieInfoStackView(title: "단백질", amountText: "\(ingredients.protein)")
            let carbonStackView = CalorieInfoStackView(title: "탄수화물", amountText: "\(ingredients.carbohydrate)")
            let fatStackView = CalorieInfoStackView(title: "지방", amountText: "\(ingredients.fat)")
            
            [totalCalorieStackView, proteinStackView, carbonStackView, fatStackView].forEach({self.addSubview($0)})
            
            totalCalorieStackView.snp.makeConstraints({
                $0.top.equalTo(self.foodNameLabel.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(17)
            })
            
            proteinStackView.snp.makeConstraints({
                $0.top.equalTo(totalCalorieStackView.snp.bottom).offset(6)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(17)
            })
            
            carbonStackView.snp.makeConstraints({
                $0.top.equalTo(proteinStackView.snp.bottom).offset(6)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(17)
            })
            
            fatStackView.snp.makeConstraints({
                $0.top.equalTo(carbonStackView.snp.bottom).offset(6)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(17)
            })
            
        } else {
            print("ingredients 값 없음")
        }
    }
    
    private func getIngredients() async throws -> Ingredients? {
        guard let foodName = self.foodNameLabel.text else { return nil }
        let components = foodName.split(separator: "/")
        
        let body: [String: Any] = [
            "descKor": components[0],
            "groupName": components[1]
        ]
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsManager.shared.accesstoken)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.post(.ingredients, parameters: body, headers: header) { (result: Result<IngredientsResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    print("결과 \(response)")
                    continuation.resume(returning: (response.content))
                case .failure(let error):
                    print("\(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
