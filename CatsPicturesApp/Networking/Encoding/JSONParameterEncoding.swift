//
//  JSONParameterEncoding.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: - JSONParameterEncoder
//
public struct JSONParameterEncoder: ParameterEncoder {
    
    ///  Takes parameters and makes them safe to be passed as URL parameters.
    /// - Parameters:
    ///   - urlRequest: urlRequest (Pass by refrence)
    ///   - parameters: parameters you need to encode them (Pass by refrence)
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw EncodingError.encodingFailed
        }
    }
}
