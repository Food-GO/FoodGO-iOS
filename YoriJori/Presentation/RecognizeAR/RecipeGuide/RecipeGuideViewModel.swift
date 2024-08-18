//
//  RecipeGuideViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

struct Recipe {
    let name: String
    let ingredients: String
    let steps: [String]
}

class RecipeGuideViewModel {
    private let networkService: NetworkService
    private(set) var recipeGuide: Recipe?
    
    private let _currentStepIndex = BehaviorRelay<Int>(value: 0)
    var currentStepIndex: Observable<Int> {
        return _currentStepIndex.asObservable()
    }
    
    private let _isPreparationStep = BehaviorRelay<Bool>(value: true)
    var isPreparationStep: Observable<Bool> {
        return _isPreparationStep.asObservable()
    }
    
    var totalSteps: Int {
        return (recipeGuide?.steps.count ?? 0) + 1
    }
    
    var canMoveToNextStep: Observable<Bool> {
        return currentStepIndex.map { $0 < self.totalSteps - 1 }
    }
    
    var canMoveToPreviousStep: Observable<Bool> {
        return currentStepIndex.map { $0 > 0 }
    }
    
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchRecipeGuide(recipeName: String) {
        networkService.getRecipeGuide(start: 1, end: 1, recipeName: recipeName) { (result: Result<RecipeGuideResponse, NetworkError>) in
            switch result {
            case .success(let response):
                if let firstRecipe = response.cookrcp01.row.first {
                    self.recipeGuide = Recipe (
                        name: firstRecipe.foodName,
                        ingredients: firstRecipe.ingredients,
                        steps: firstRecipe.manuals
                    )
                    self._currentStepIndex.accept(0)
                    self._isPreparationStep.accept(true)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchMockRecipe() {
        self.recipeGuide = Recipe (
            name: "토마토 달걀 볶음",
            ingredients: "",
            steps: [
                "세척한 토마토는 꼭지를 제거하고 편으로 썰고, 대파는 송송 썰어주세요.\n달걀은 잘 풀어 소금을 뿌려 주세요.",
                "팬에 식용유1/4컵(30g)를 두르고",
                "스크램블 에그를 만들어 그릇에 담아주세요",
                "팬에 식용유1/4컵(30g)를 두르고",
                "대파1/2컵 (40g)를 넣어 파기름을 내주세요",
                "대파가 노릇해지면 토마토를 넣어 함께 볶아주세요",
                "프라이팬 바닥에 진간장 1큰술(10g), 굴소스 1큰술(10g)를 넣고 누르듯이 볶아주세요",
                "기호에 맞춰 꽃소금으로 간을 맞추고, 후춧가루를 뿌려주세요",
                "만들어 둔 스크램블 에그를 팬에 넣어 함께 볶아주세요",
                "마지막으로 불을 끄고 참기름을 넣어 섞어주세요.",
                "그릇에 담으면, 완성!"
            ]
        )
        self._currentStepIndex.accept(0)
        self._isPreparationStep.accept(true)
    }
    
    func moveToNextStep() {
        let nextIndex = min(_currentStepIndex.value + 1, totalSteps - 1)
        _currentStepIndex.accept(nextIndex)
    }
    
    func moveToPreviousStep() {
        let previousIndex = max(_currentStepIndex.value - 1, 0)
        _currentStepIndex.accept(previousIndex)
    }
    
    func getCurrentStep() -> String? {
        guard let recipeGuide = recipeGuide else { return nil }
        let index = _currentStepIndex.value
        if index == 0 {
            return "재료 준비: \(recipeGuide.ingredients)"
        } else {
            return recipeGuide.steps[index - 1]
        }
    }
    
    func getStepTitle(for index: Int) -> String {
        return index == 0 ? "재료 준비" : "재료 손질"
    }
}
