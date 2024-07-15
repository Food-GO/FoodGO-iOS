//
//  SecondRegistViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SecondRegistViewModel {
    let nicknameRelay = BehaviorRelay<String>(value: "")
    
    private let requestNicknameDuplicatedRelay = BehaviorRelay<Bool>(value: true)
    
    var isValidateButtonEnabled: Observable<Bool> {
        return nicknameRelay
            .map { !$0.isEmpty }
            .asObservable()
    }
    
    var isValidateNextButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(nicknameRelay, requestNicknameDuplicatedRelay)
            .map { nickname, isDuplicated in
                return nickname.count > 0 && !isDuplicated
            }
    }
    
    func requestNicknameDuplicated() {
        requestNicknameDuplicatedRelay.accept(false)
    }
    
}
