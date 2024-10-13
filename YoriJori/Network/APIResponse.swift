//
//  APIResponse.swift
//  YoriJori
//
//  Created by 김강현 on 10/13/24.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let statusCode: String
    let message: String
    let content: T
}
