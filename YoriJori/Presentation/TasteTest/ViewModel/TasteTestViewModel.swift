//
//  TasteTestViewMdoel.swift
//  YoriJori
//
//  Created by 김강현 on 7/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class TasteTestViewModel {
    let selectedButtonIndex = BehaviorRelay<Int?>(value: nil)
    
    let isNextButtonEnabled: Observable<Bool>
    
    init() {
        isNextButtonEnabled = selectedButtonIndex.map { $0 != nil }
    }
    
    func selectButton(at index: Int) {
        selectedButtonIndex.accept(index)
    }
}
