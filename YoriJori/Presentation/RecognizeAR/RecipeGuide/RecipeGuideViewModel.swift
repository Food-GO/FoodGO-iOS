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
