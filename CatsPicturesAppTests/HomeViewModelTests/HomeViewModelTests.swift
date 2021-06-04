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
        PhotoStore.shared.clear()
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
        let errorMessage = "Request failed, but it's my fault"
        
        let state: State = .error
        
        // When
        sut.viewDidLoad()
        photoUseCase.testExcutePhotoList_FailureCase_FailedAndReturnError()
        
        // Then
        XCTAssertEqual(sut.state, state)
        XCTAssertEqual(sut.alertMessage, errorMessage)
        
    }
    
    /// test saving new favorite
    ///
    func  testSaveFavorite_SuccessSavingeNewPhoto_ReturnTrue() {
        
        // Given
        let photoStore = PhotoStore.shared
        
        // When
        let expecation = XCTestExpectation()
        
        sut.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        
        // Then
        let fetchResultsController =  photoStore.fetchResultsController
        try? fetchResultsController.performFetch()
        XCTAssertEqual(fetchResultsController.sections?.count, 1)
        XCTAssertEqual(fetchResultsController.object(at: IndexPath(item: .zero, section: .zero)).photoUrl, "imageurl")
        XCTAssertEqual(fetchResultsController.object(at: IndexPath(item: .zero, section: .zero)).photoId, "photoId")
    }
    
    /// test remve favorite item
    ///
    func  testRemoveFavorite_SuccessRemovingNewPhoto_ReturnTrue() {
        // Given
        
        let photoStore = PhotoStore.shared
        let expecation = XCTestExpectation()
        
        sut.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        // When
        let expecation2 = XCTestExpectation()
        sut.removeFromFavorite("photoId") { (error) in
            XCTAssertNil(error)
            expecation2.fulfill()
        }
        wait(for: [expecation2], timeout: Constants.expectationTimeout)
        
        // Then
        let fetchResultsController =  photoStore.fetchResultsController
        try? fetchResultsController.performFetch()
        XCTAssertEqual(fetchResultsController.sections?.count, .zero)
    }
    
    ///
    ///
    func testIsExistItem_SuccessFoundItem_ReturnTrue() {
        // Given
        let expecation = XCTestExpectation()
        
        // When
        photoUseCase.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        
        // Then
        XCTAssertTrue(photoUseCase.isExist("photoId"))
    }
}
