//
//  ParameterEncoding.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

public typealias Parameters = [String: Any]

// MARK: - Parameter Encoder Protocol
//
public protocol ParameterEncoder {
    
    /// Used for encod paramters (in url and body ) of netwoek request
    /// - Parameters:
    ///   - urlRequest: URLRequest (Pass by refrence)
    ///   - parameters: Parameters you need to encode them (Pass by refrence)
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

// MARK: - ParameterEncoding
/// Have all the different styles of encoders you need
///
public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    
    func encode(urlRequest: inout URLRequest,
                bodyParameters: Parameters?,
                urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        } catch {
            throw error
        }
    }
}

// MARK: - Encoding Error
/// Handling falilure of encoding paramters
///
public enum EncodingError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
