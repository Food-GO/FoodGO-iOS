//
//  LoginViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

enum LoginError: Error {
    case badRequest
    case serverError
}

enum LoginResult {
    case success
    case failure(message: String)
}

class LoginViewModel {
    let idRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    
    var loginResult = PublishSubject<LoginResult>()
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(idRelay, passwordRelay)
            .map { id, password in
                return !id.isEmpty && !password.isEmpty
            }
    }
    
    func requestLogin() {
        let id = idRelay.value
        let pw = passwordRelay.value
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let success = (id == "test" && pw == "password")
            
            DispatchQueue.main.async {
                if success {
                    self?.loginResult.onNext(.success)
                } else {
                    self?.loginResult.onNext(.failure(message: "Invalid credentials"))
                }
            }
        }
    }
    
    
}
