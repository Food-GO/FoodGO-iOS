//
//  FirstRegisterViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/9/24.
//

import Foundation

import RxCocoa
import RxSwift

class IDPasswordViewModel {
    let idRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    let passwordValidateRelay = BehaviorRelay<String>(value: "")
    let validateIDTrigger = PublishRelay<Void>()
    
    lazy var isValidateIdButtonEnabled: Observable<Bool> = {
        return idRelay
            .map { !$0.isEmpty }
            .asObservable()
    }()
    
    lazy var isValidateNextButtonEnabled: Observable<Bool> = {
        return Observable
            .combineLatest(passwordRelay, passwordValidateRelay, isIDDuplicated)
            .map { password, validatePassword, isDuplicated in
                return password.count >= 10 && password == validatePassword && !isDuplicated
            }
    }()
    
    lazy var isIDDuplicated: Observable<Bool> = {
        return validateIDTrigger
            .withLatestFrom(idRelay)
            .flatMapLatest { [weak self] id -> Observable<Bool> in
                guard let self = self, !id.isEmpty else {
                    return .just(true)
                }
                return self.checkIdDuplicated(id: id)
            }
            .share()
    }()
    
    private let disposeBag = DisposeBag()
    
    private func checkIdDuplicated(id: String) -> Observable<Bool> {
        let endpoint = APIEndpoint.userNameCheck(username: id)
        
        return Observable.create { observer in
            NetworkService.shared.get(endpoint) { (result: Result<IDDuplicatedResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    observer.onNext(response.content)
                case .failure:
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
