//
//  PagingControllerTests.swift.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
@testable import CatsPicturesApp

import XCTest

class PagingControllerTests: XCTestCase {
    
    func testShouldLoadNextPage_WhileLoading_ReturnsFalse() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When & Then
        XCTAssertFalse(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPage_IfNothingIsLoading_ReturnsTrue() throws {
        // Given
        let pagingController = PagingController()

        // When & Then
        XCTAssertTrue(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPage_IfLastPageNotLoaded_ReturnsTrue() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When
        pagingController.loadedPage()

        // Then
        XCTAssertTrue(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPage_IfLastPageNotLoadedButStartedLoading_ReturnsFalse() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When
        pagingController.loadedPage()
        pagingController.startLoadingNextPage()

        // Then
        XCTAssertFalse(pagingController.shouldLoadNextPage)
    }
}
