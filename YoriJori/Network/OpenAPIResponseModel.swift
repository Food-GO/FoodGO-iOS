//
//  ResponseModel.swift
//  YoriJori
//
//  Created by 김강현 on 8/11/24.
//

import Foundation
import Alamofire

struct RecipeGuideResponse: Codable {
    let cookrcp01: OpenAPIRecipeGuide
    
    enum CodingKeys: String, CodingKey {
        case cookrcp01 = "COOKRCP01"
    }
}

// MARK: - COOKRCP01
struct OpenAPIRecipeGuide: Codable {
    let totalCount: String
    let row: [RecipeGuide]
    let result: OpenAPIResult
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row
        case result = "RESULT"
    }
}

// MARK: - Recipe
struct RecipeGuide: Codable {
    let ingredients: String
    let manuals: [String]
    let foodName: String
    
    enum CodingKeys: String, CodingKey {
        case ingredients = "RCP_PARTS_DTLS"
        case foodName = "RCP_NM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredients = try container.decode(String.self, forKey: .ingredients)
        foodName = try container.decode(String.self, forKey: .foodName)
        
        var manuals: [String] = []
        let additionalContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for i in 1...20 {
            let key = DynamicCodingKeys(stringValue: "MANUAL\(String(format: "%02d", i))")!
            if let manual = try additionalContainer.decodeIfPresent(String.self, forKey: key), !manual.isEmpty {
                manuals.append(manual)
            }
        }
        self.manuals = manuals
    }
}

// MARK: - DynamicCodingKeys
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

// MARK: - Result
struct OpenAPIResult: Codable {
    let msg, code: String
    
    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}
