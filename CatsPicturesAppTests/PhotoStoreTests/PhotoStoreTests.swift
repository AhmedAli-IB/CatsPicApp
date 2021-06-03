//
//  PhotoStoreTests.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 03/06/2021.
//

import XCTest
import CoreData
@testable import CatsPicturesApp

// MARK: - PhotoStoreTests
//
class PhotoStoreTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        PhotoStore.shared.clear()
    }
    /// test saving new favorite
    ///
    func  testSaveFavorite_SuccessSavingeNewPhoto_ReturnTrue() {
        let photoStore = PhotoStore.shared

        // When
        let expecation = XCTestExpectation()
        photoStore.savePhoto(photo: CatsResponse(url: "imageurl")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)

        // Then
       let fetchResultsController =  photoStore.fetchResultsController
       try? fetchResultsController.performFetch()
       XCTAssertEqual(fetchResultsController.sections?.count, 1)
        
        XCTAssertEqual(fetchResultsController.object(at: IndexPath(item: .zero, section: .zero)).photoUrl, "imageurl")

    }
    /// test remve favorite item
    ///
    func  testRemoveFavorite_SuccessRemovingNewPhoto_ReturnTrue() {
        let photoStore = PhotoStore.shared

        // When
        let expecation = XCTestExpectation()
        photoStore.savePhoto(photo: CatsResponse(url: "imageurl")) { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: Constants.expectationTimeout)
        // Then
        let expecation2 = XCTestExpectation()
        photoStore.deletePhoto(photo: CatsResponse(url: "imageurl")) { (error) in
            XCTAssertNil(error)
            expecation2.fulfill()
        }
        wait(for: [expecation2], timeout: Constants.expectationTimeout)

        // Then
       let fetchResultsController =  photoStore.fetchResultsController
       try? fetchResultsController.performFetch()
        XCTAssertEqual(fetchResultsController.sections?.count, .zero)
    }
}
