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
    
    let selectedButtonIndex = BehaviorRelay<Int?>(value: nil)
}
