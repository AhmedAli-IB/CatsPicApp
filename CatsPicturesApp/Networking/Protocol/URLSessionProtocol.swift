//
//  URLSessionProtocol.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: - URLSessionDataTaskProtocol
//
protocol URLSessionProtocol {
    
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

// MARK: - URLSessionDataTaskProtocol
//
protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

// MARK: - Conform the protocol
//
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
// MARK: - URLSessionDataTask
//
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
