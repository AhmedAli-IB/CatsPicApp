//
//  CatEndPoint.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: - CatEndPoint
/// `CatEndPoint` include all api's related to cats api
///
enum CatEndPoint {
    case getCats(page: Int, limit: Int)
}

// MARK: - EndPointType
/// `CatEndPoint `Conform to EndPointType
///
extension CatEndPoint: EndPointType {
    
    var baseURL: URL {
        return Environment.baseURL
    }
    
    var path: String {
        
        switch self {
        case .getCats:
            return "/images/search"
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .getCats:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
        case .getCats(let page, let limit):
            return .requestParameters(bodyParameters: nil,
                                       bodyEncoding: .urlEncoding,
                                       urlParameters: ["page": page,
                                                       "limit": limit,
                                                       "api_key": Environment.apiKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
