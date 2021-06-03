//
//  PhotoUseCaseMock.swift
//  CatsPicturesAppTests
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
@testable import CatsPicturesApp

// MARK: - PhotoUseCaseMock
//
class PhotoUseCaseMock: PhotoUseCaseType {
    // MARK: - Propertes
    //
    var executeCalled = false
    var cats: [CatsResponse] = []
    var completeClosure: ((Result<[CatsResponse], NetworkError>) -> Void)?
    
    // MARK: - Handlers
    //
    func getRandomPhotos(page: Int, limit: Int, onCompletion: @escaping (Result<[CatsResponse], NetworkError>) -> Void) {
        executeCalled = true
        completeClosure = onCompletion
    }
    /// Test success case for receive list of cat photos
    ///
    func testExcutePhotoList_SuccessCase_ReturnTrue() {
        completeClosure?(.success(cats))
    }
    /// Test faliure case for receive list of cat photos
    ///
    func testExcutePhotoList_FailureCase_FailedAndReturnError() {
        completeClosure?(.failure(NetworkError.clientError))
    }
    
}
