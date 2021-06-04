//
//  NetworkLayerTests.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
import XCTest
@testable import CatsPicturesApp

class NetworkLayerTests: XCTestCase {
    
    // MARK: - Properties
    //
    var sut: NetworkManager<EndPointTypeMock>!
    
    // MARK: - Lifecycle
    //
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? super.setUpWithError()
        sut = NetworkManager()
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try? super.tearDownWithError()
        sut = nil
        
    }
    
    // MARK: - Tests
    //
    /// Test  URL Encoding
    ///
    func testURLEncoding_ReturnTrue() {
        
        guard let url = URL(string: "https:www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: Parameters = [
            "UserID": 1,
            "Name": "Ahmed",
            "Email": "AhmedEmail"
        ]
        
        do {
            let encoder = URLParameterEncoder()
            try encoder.encode(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }
            
            let expectedURL = "https:www.google.com/?Name=Ahmed&Email=AhmedEmail&UserID=1"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        } catch {
            
        }
    }
    
    /// Test success request and retrive request from
    ///
    func testRequest_SuccessRequest_ReturnTrue() {
        // When
        let promise = XCTestExpectation()
        
        sut.request(api: .testGetHttpMethod) { (result: Result<[CatsResponse], NetworkError>) in
            switch result {
            // Then
            case .success(let response):
                
                XCTAssertTrue(response.count > .zero)
            case .failure(let error):
                XCTAssertNil(error)
            }
            promise.fulfill()
            
        }
        
        wait(for: [promise], timeout: Constants.expectationTimeout)
    }
    
    /// Test failure request return with server error
    ///
    func testRequest_FailureRequestWithServerError_ReturnTrue() {
        
        // When
        let promise = XCTestExpectation()
        
        sut.request(api: .testFailureServerError) { (result: Result<[CatsResponse], NetworkError>) in
            switch result {
            // Then
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertEqual(error, .serverError)
            }
            promise.fulfill()
            
        }
        
        wait(for: [promise], timeout: Constants.expectationTimeout)
    }
    /// Test failure request return with encoding error
    ///
    func testRequest_FailureRequestWithEncodingError_ReturnTrue() {
        // When
        let promise = XCTestExpectation()
        
        sut.request(api: .testGetHttpMethod) { (result: Result<FailureModel, NetworkError>) in
            switch result {
            // Then
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertEqual(error, .unableToDecode)
            }
            promise.fulfill()
            
        }
        
        wait(for: [promise], timeout: Constants.expectationTimeout)
    }
    
    /// Test failure request return with client error
    ///
    func testRequest_FailureRequestWithClientError_ReturnTrue() {
        // When
        let promise = XCTestExpectation()
        
        sut.request(api: .testClientError) { (result: Result<FailureModel, NetworkError>) in
            switch result {
            // Then
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertEqual(error, .clientError)
            }
            promise.fulfill()
            
        }
        
        wait(for: [promise], timeout: Constants.expectationTimeout)
    }
    
}
