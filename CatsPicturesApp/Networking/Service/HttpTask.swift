//
//  HttpTask.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

typealias HTTPHeaders = [String: String]

// MARK: - HTTPTask
/// `HTTPTask` is responsible for configuring parameters for a specific endPoint.
///
 enum HTTPTask {
    // Plain request
    case request
    
    // Request with normal headers
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    // Request with addition Headers
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
