//
//  Routable.swift
//  ProjectMVVM
//
//  Created by Atul Gupta on 04/01/23.
//

import Foundation

protocol Routable {
    var url: URL { get }
    var method: HTTPMethod { get }
    var endPoint: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}

extension Routable {
    
    var headers: [String: String] {
        var headers: [String: String] = [:]
        
        headers["Content-Type"] = "application/json"
        headers["platform"] = "iOS"
        
        if let versionCode = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            headers["iOSVersionCode"] = versionCode
        }
        
//        if let token = Defaults.shared.accessToken, token != "" {
//            headers["Authorization"] = "Bearer \(token)"
//        }
        
        return headers
    }
    
    var request: URLRequest {
        var request                 = URLRequest(url: self.url)
        request.httpMethod          = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody            = self.body
        request.cachePolicy         = .reloadRevalidatingCacheData
        return request
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
