//
//  NetworkManager.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
// MARK: - NetworkClient
/// `NetworkManager` responsible for perform request
//
class NetworkManager<G: EndPointType> {
    
    // MARK: - Properties
    //
    let router = Router<G>()
    
    // MARK: - Handlers
    
    /// Perform network call and return with result
    /// - Parameters:
    ///   - api: End pointe to extcue
    ///   - completion: Result with success data or falilure error
    func request<T: Decodable>(api: G, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        router.request(api) { data, response, error in
            
            // error
            if  error != nil {
                completion(.failure(.clientError))
                return
            }
            
            // check response status code
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError))
                return
            }
            // check respose data
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            // decode response
            guard let apiResponse = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.unableToDecode))
                
                return
            }
            
            completion(.success(apiResponse))
            
        }
    }
}
