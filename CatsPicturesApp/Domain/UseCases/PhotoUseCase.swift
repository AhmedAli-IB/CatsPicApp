//
//  PhotoUseCase.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
import CoreData
// MARK: - PhotoUseCaseType
//
protocol PhotoUseCaseType {
    func getRandomPhotos(page: Int, limit: Int, onCompletion: @escaping (Result<[CatsResponse], NetworkError>) -> Void )
    func saveToFavorite(_ photo: CatsResponse, onCompletion: ((PhotosStoreError?) -> Void)?)
    func removeFromFavorite(_ photoId: String, onCompletion: ((PhotosStoreError?) -> Void)?)
    func isExist(_ photoId: String) -> Bool
    
}
// MARK: - PhotoUseCase
/// `PhotoUseCase` responsible for handle domain data layer (Remote api or local database)
///
final class PhotoUseCase: PhotoUseCaseType {
    
    // MARK: - Properties
    //
    let network = NetworkManager<CatEndPoint>()
    
    /// Request API to get random of cats photo
    /// - Parameters:
    ///   - page: current needed page
    ///   - limit: size of page
    ///   - onCompletion: On success return with array of cats object OR on failure return with error
    func getRandomPhotos(page: Int, limit: Int, onCompletion: @escaping (Result<[CatsResponse], NetworkError>) -> Void) {
        
        network.request(api: .getCats(page: page, limit: limit)) { (result: Result<[CatsResponse], NetworkError>) in
            switch result {
            case .success(let response):
                onCompletion(.success(response))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    /// Add  photo to  favorite
    /// - Parameters:
    ///   - photo: item to be favorite
    ///   - onCompletion: error callback in case of failure
    func saveToFavorite(_ photo: CatsResponse, onCompletion: ((PhotosStoreError?) -> Void)? = nil) {
        PhotoStore.shared.savePhoto(photo: photo) { error in
            guard error == nil  else {
                onCompletion?(error)
                return
            }
            onCompletion?(nil)
        }
    }
    
    /// Remove photo from favorite
    /// - Parameters:
    ///   - photoId: item id to be deleted
    ///   - onCompletion: error callback in case of failure
    func removeFromFavorite(_ photoId: String, onCompletion: ((PhotosStoreError?) -> Void)? = nil) {
        PhotoStore.shared.deletePhoto(photoId: photoId) { error in
            guard error == nil  else {
                onCompletion?(error)
                return
            }
            onCompletion?(nil)
        }
    }
    
    /// check existence of item
    /// - Parameter photoId: item id to be deleted
    /// - Returns: if exist return true else return fasle
    func isExist(_ photoId: String) -> Bool {
        return PhotoStore.shared.countObjects(photoId: photoId) > .zero
    }
}
