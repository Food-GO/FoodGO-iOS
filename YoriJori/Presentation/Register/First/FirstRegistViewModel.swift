//
//  FirstRegisterViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/9/24.
//

import Foundation
import RxCocoa
import RxSwift

struct UserCheckResponse: Codable {
    let statusCode: String
    let message: String
    let content: Bool
    
    var isDuplicated: Bool {
        return content
    }
}

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
        let id = idRelay.value
        if id.isEmpty {
            requestIdDuplicatedRelay.accept(true)
        }
        
        checkIdDuplicated(id: id)
    }
    
    func checkIdDuplicated(id: String) {
        let endpoint = APIEndpoint.userNameCheck(username: id)
        
        NetworkService.shared.get(endpoint) { [weak self] (result: Result<UserCheckResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.requestIdDuplicatedRelay.accept(response.isDuplicated)
            case .failure(let error):
                self.requestIdDuplicatedRelay.accept(true)
            }
        }
    }
    
    
}
