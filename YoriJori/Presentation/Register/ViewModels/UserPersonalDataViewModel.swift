//
//  ThirdRegistViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/15/24.
//

import RxSwift
import RxCocoa

class UserPersonalDataViewModel {
    let usageCategories = ["식재료관리", "요리추천 및 레시피", "식단관리", "챌린지"]
    let diseaseCategories = ["당뇨", "고지혈증", "통풍"]
    let lifestyleHabitCategories = ["하루 2끼만 먹어요", "아침을 안먹어요", "저녁을 안먹어요"]
    
    let usageSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
    let diseaseSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
    let lifestyleSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
}
