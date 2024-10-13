//
//  LoginRequestModel.swift
//  YoriJori
//
//  Created by 김강현 on 7/7/24.
//

import Foundation

typealias LoginResponse = APIResponse<Token>

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
