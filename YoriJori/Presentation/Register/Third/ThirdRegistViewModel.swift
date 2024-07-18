//
//  ThirdRegistViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/15/24.
//

import RxSwift
import RxCocoa

class ThirdRegistViewModel {
    let usageCategories = ["식단 기록", "요리 레시피", "식재료 관리", "커뮤니티", "음식 추천", "식습관 개선", "식습관 리포트"]
    let diseaseCategories = ["당뇨", "고혈압", "고지혈증", "통풍", "지방간"]
    let lifestyleHabitCategories = ["하루 2끼만 먹어요", "아침을 안먹어요", "저녁을 안먹어요"]
    
    let usageSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
    let diseaseSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
    let lifestyleSelectedButtonIndex = BehaviorRelay<Int?>(value: nil)
}
