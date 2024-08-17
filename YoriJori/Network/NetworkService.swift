//
//  NetworkService.swift
//  YoriJori
//
//  Created by 김강현 on 8/3/24.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case userNameCheck(username: String)
    case ingredients
    case cuisines
    case challenges
    case notification
    case openAPI(start: Int, end: Int, recipeName: String)
    
    private var baseUrl: String {
        let url = Bundle.main.object(forInfoDictionaryKey: "Base_URL") as? String ?? ""
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cleaned = trimmed.replacingOccurrences(of: "\\/\\/", with: "//")
        
        return cleaned
    }
    
    private var openKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "Open_Key") as? String ?? ""
    }
    
    var path: String {
        switch self {
        case .userNameCheck(let username):
            return "/users/username?username=\(username)"
        case .ingredients:
            return "/ingredients"
        case .cuisines:
            return "/cuisines"
        case .challenges:
            return "/challenges"
        case .notification:
            return "/notification"
        case .openAPI(let start, let end, let recipeName):
            let encodedRecipeName = recipeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? recipeName
            return "http://openapi.foodsafetykorea.go.kr/api/\(openKey)/COOKRCP01/json/\(start)/\(end)/RCP_NM=\(encodedRecipeName)"        }
    }
    
    var url: URL? {
        switch self {
        case .openAPI:
            return URL(string: path)
        default:
            let urlString = baseUrl + path
            return URL(string: urlString)
        }
    }
    
    func debugInfo() -> String {
        return """
            Endpoint: \(self)
            Base URL: \(baseUrl)
            Path: \(path)
            Full URL: \(url?.absoluteString ?? "Invalid URL")
            """
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case networkError(AFError)
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from the server"
        case .decodingError:
            return "Failed to decode the response"
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError(let afError):
            return "Network error: \(afError.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}

class NetworkService {
    static let shared = NetworkService()
    private init () {}
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        LoadingIndicator.showLoading()
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
        .validate()
        .responseData { response in
            print("Status Code: \(response.response?.statusCode ?? 0)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Raw Response: \(utf8Text)")
            }
            
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(.decodingError))
                }
                LoadingIndicator.hideLoading()
            case .failure(let error):
                let networkError = self.handleNetworkError(error)
                completion(.failure(networkError))
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    private func handleNetworkError(_ error: AFError) -> NetworkError {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            
            switch code {
            case NSURLErrorNotConnectedToInternet:
                return .networkError(error)
            case NSURLErrorCannotFindHost,
            NSURLErrorCannotConnectToHost:
                return .networkError(error)
            case NSURLErrorTimedOut:
                return .networkError(error)
            default:
                return .unknownError
            }
        }
        
        switch error {
        case .responseValidationFailed(let reason):
            switch reason {
            case .dataFileNil, .dataFileReadFailed:
                return .noData
            case .missingContentType, .unacceptableContentType:
                return .serverError("Invalid content type")
            case .unacceptableStatusCode(let code):
                return .serverError("Unacceptable status code: \(code)")
            default:
                return .unknownError
            }
        case .responseSerializationFailed(let reason):
            switch reason {
            case .inputDataNilOrZeroLength:
                return .noData
            case .decodingFailed:
                return .decodingError
            default:
                return .unknownError
            }
        default:
            return .unknownError
        }
    }
    
    func get<T: Decodable>(_ endpoint: APIEndpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(endpoint, method: .get, parameters: parameters, headers: headers, completion: completion)
    }
    
    func post<T: Decodable>(_ endpoint: APIEndpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(endpoint, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    func put<T: Decodable>(_ endpoint: APIEndpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(endpoint, method: .put, parameters: parameters, headers: headers, completion: completion)
    }
    
    func delete<T: Decodable>(_ endpoint: APIEndpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(endpoint, method: .delete, parameters: parameters, headers: headers, completion: completion)
    }
    
    func getRecipeGuide<T: Decodable>(start: Int, end: Int, recipeName: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        get(.openAPI(start: start, end: end, recipeName: recipeName), completion: completion)
    }
}
