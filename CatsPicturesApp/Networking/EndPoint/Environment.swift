//
//  Environment.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: - Environment
/// `Environment` responsible for build root url based on value in info.plist
///
enum Environment {
    
    // MARK: - Keys
    //
    enum PlistKeys {
        static let baseURL = "BASE_URL"
        static let apiKey = "API_KEY"
    }
    
    // MARK: - Plist
    //
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    // MARK: - Plist values
    // Server URL
    static let baseURL: URL = {
        guard let baseURLString = Environment.infoDictionary[PlistKeys.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment \(#function)")
        }
        guard let url = URL(string: baseURLString ) else {
            fatalError("Root URL is invalid")
        }
        print("url version", url.absoluteString)
        return url
    }()
    
    // api key
    static let apiKey: String = {
        guard let apiKey = Environment.infoDictionary[PlistKeys.apiKey] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return apiKey
    }()
}
