//
//  FavoriteViewModelTests.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 04/06/2021.
//

import Foundation
import XCTest
@testable import CatsPicturesApp

// MARK: - FavoriteViewModelTests
//
class FavoriteViewModelTests: XCTestCase {
    
    // MARK: - Properties
    //
    var sut: FavoriteViewModel!
    var photoUseCase: PhotoUseCaseMock!
    
    // MARK: - Lifecycle
    //
    override func setUp() {
        super.setUp()
        photoUseCase = PhotoUseCaseMock()
        sut = FavoriteViewModel(photoUseCase: photoUseCase)
    }
    
    override func tearDown() {
        sut = nil
        photoUseCase = nil
        PhotoStore.shared.clear()
        super.tearDown()
    }
    
    /// test fetch  saved favorite photos
    ///
    func  testFetchFavorite_SuccessFetchingPhotos_ReturnTrue() {
        
        // When
        let expecation = XCTestExpectation()
        
        photoUseCase.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        
        // Then
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.fetchResultsController.sections?.count, 1)
        XCTAssertEqual(sut.fetchResultsController.object(at: IndexPath(item: .zero, section: .zero)).photoUrl, "imageurl")
        XCTAssertEqual(sut.fetchResultsController.object(at: IndexPath(item: .zero, section: .zero)).photoId, "photoId")
    }
    
    /// test state when fetch count equal zero
    ///
    func  testStateValue_WhenEqualEmpty_ReturnTrue() {
        // When
        
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.fetchResultsController.sections?.count, 0)
        XCTAssertEqual(sut.numberOfSection, .zero)
        XCTAssertEqual(sut.state, .empty)
        XCTAssertNil(sut.alertMessage)
        
    }
    /// test remove item from favorite
    ///
    func  testRemoveFavorite_SuccessRemovingNewPhoto_ReturnTrue() {
        // Given
        
        let photoStore = PhotoStore.shared
        let expecation = XCTestExpectation()
        
        photoUseCase.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        
        sut.viewDidLoad()
        
        // When
        let expecation2 = XCTestExpectation()
        sut.removeFromFavorite(for: IndexPath(row: .zero, section: .zero)) { (error) in
            XCTAssertNil(error)
            expecation2.fulfill()
        }
        wait(for: [expecation2], timeout: Constants.expectationTimeout)
        
        // Then
        let fetchResultsController =  photoStore.fetchResultsController
        try? fetchResultsController.performFetch()
        XCTAssertEqual(fetchResultsController.sections?.count, .zero)
    }
    
    /// test create cell view model  item.
    ///
    func  testCreateCellViewModel_SuccessCreatation_ReturnTrue() {
        // Given
        
        let expecation = XCTestExpectation()
        
        photoUseCase.saveToFavorite(CatsResponse(url: "imageurl", id: "photoId")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        
        sut.viewDidLoad()
        XCTAssertTrue(sut.createCellViewModel(for: IndexPath(row: .zero, section: .zero)).isFavorite)
        
    }
}
