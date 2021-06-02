//
//  URLParameterEncoding.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: Encoder URLParameter
//
public struct URLParameterEncoder: ParameterEncoder {
   
   /// Used for encod paramters (in url and body ) of netwoek request
   /// - Parameters:
   ///   - urlRequest: URLRequest (Pass by refrence)
   ///   - parameters: Parameters you need to encode them (Pass by refrence)
   public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
       
       guard let url = urlRequest.url else { throw EncodingError.missingURL }
       
       if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
           urlComponents.queryItems = [URLQueryItem]()
           for (key, value) in parameters {
               let queryItem = URLQueryItem(name: key, value: String(describing: value))
               urlComponents.queryItems?.append(queryItem)
           }
           urlRequest.url = urlComponents.url
       }
       
       if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
           urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
       }
       
   }
}
