//
//  FirstRegisterViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/9/24.
//

import Foundation
import RxCocoa
import RxSwift

class FirstRegistViewModel {
    let idRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    let passwordValidateRelay = BehaviorRelay<String>(value: "")
    
    private let requestIdDuplicatedRelay = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    
    var isValidateIdButtonEnabled: Observable<Bool> {
        return idRelay
            .map { !$0.isEmpty }
            .asObservable()
    }
    
    var isValidateNextButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(passwordRelay, passwordValidateRelay, requestIdDuplicatedRelay)
            .map { password, validatePassword, isDuplicated in
                return password.count >= 10 && password == validatePassword && !isDuplicated
            }
    }
    
    func requestIdDuplicated() {
        requestIdDuplicatedRelay.accept(false)
    }
    
    
}
