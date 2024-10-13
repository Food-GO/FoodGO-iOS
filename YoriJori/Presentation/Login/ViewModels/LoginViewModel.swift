//
//  LoginViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        
        let parameters: [String: Any] = [
            "username": id,
            "password": pw
        ]
        
        NetworkService.shared.post(.login, parameters: parameters) { (result: Result<LoginResponse, NetworkError>) in
            switch result {
            case .success(let response):
                UserDefaultsManager.shared.accesstoken = response.content.accessToken
                UserDefaultsManager.shared.refreshtoken = response.content.refreshToken
                self.loginResult.onNext(.success)
            case .failure(let error):
                self.loginResult.onNext(.failure(message: "\(error)"))
            }
        }
    }
}
