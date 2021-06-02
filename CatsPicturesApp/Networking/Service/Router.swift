//
//  Router.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
// MARK: - Router
/// `Router` responsable for build and make network call using `URLSession`
//
class Router<EndPoint: EndPointType>: NetworkRouter {
    
    // MARK: - Properties
    //
    private var task: URLSessionDataTaskProtocol?
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        
    }
    
    // MARK: - Handlers
    
    /// Make network requesr
    /// - Parameters:
    ///   - route: End point to execute that conform to `EndPointType`
    ///   - completion: Completion with data, response and error
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    /// Called at any time in the life cycle of a request and cancel it.
    ///
    func cancel() {
        self.task?.cancel()
    }
    
}
// MARK: - Private Handlers
//
private extension Router {
    
    /// Converting `EndPointType` to `URLRequest`
    /// - Parameter route: End point to execute that conform to `EndPointType`
    /// - Returns: URLRequest
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    /// Configure parameters encoding
    /// - Parameters:
    ///   - bodyParameters: Parameters to encode in body
    ///   - bodyEncoding: Type of encoding (url, body)
    ///   - urlParameters: Parameters to encode in url
    ///   - request: URL request
    func configureParameters(bodyParameters: Parameters?,
                             bodyEncoding: ParameterEncoding,
                             urlParameters: Parameters?,
                             request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    /// Add additional headers to request
    /// - Parameters:
    ///   - additionalHeaders: Headers need to add
    ///   - request: URL request
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
