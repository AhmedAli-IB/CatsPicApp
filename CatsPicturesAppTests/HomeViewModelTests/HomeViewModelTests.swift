//
//  HomeViewModelTests.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 03/06/2021.
//

import XCTest
@testable import CatsPicturesApp

// MARK: - HomeViewModelTests
//
class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    //
    var sut: HomeViewModel!
    var photoUseCase: PhotoUseCaseMock!
    
    // MARK: - Lifecycle
    //
    override func setUp() {
        super.setUp()
        photoUseCase = PhotoUseCaseMock()
        sut = HomeViewModel(photoUseCase: photoUseCase)
    }
    
    override func tearDown() {
        sut = nil
        photoUseCase = nil
        super.tearDown()
    }
    
    /// Test hit random photo list end point
    ///
    func testHitPhotoListEndPoint_ReturnTrue() {
        // Given
        let state: State = .populated

        // When
        sut.viewDidLoad()
        // Then
        XCTAssert(photoUseCase.executeCalled)
        
        photoUseCase.testExcutePhotoList_SuccessCase_ReturnTrue()

        XCTAssertEqual(state, sut.state)
    }
    
    /// Test hit photo list end point but return with client error
    ///
    func testHitPhotoListEndPoint_FailureRequestWithClientError_ReturnTrue() {
        // Given
        let errorMessage = "failed to build request"
        
        let state: State = .error
        
        // When
        sut.viewDidLoad()
        photoUseCase.testExcutePhotoList_FailureCase_FailedAndReturnError()

        // Then
        XCTAssertEqual(sut.state, state)
        XCTAssertEqual(sut.alertMessage, errorMessage)
        
    }

}
