//
//  NetworkRouterProtocol.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

// MARK: - Network router protocol
/// `NetworkRouter` Responsible for making requests and once the request is made it passes the response to the completion
//
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
