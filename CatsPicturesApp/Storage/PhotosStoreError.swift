//
//  PhotosStoreError.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation

// MARK: - PhotosStoreError
/// `PhotosStoreError` responsible for handling storage error
///
enum PhotosStoreError: Equatable, Error {
    
    case saveError(error: Error)
    case deleteError(error: Error)
    
    static func == (lhs: PhotosStoreError, rhs: PhotosStoreError) -> Bool {
        switch (lhs, rhs) {
        case (.saveError, .saveError):
            return true
        case (.deleteError, .deleteError):
            return true
        default :
            return false
        }
    }
    
    var description: String {
        switch self {
        case .saveError:
            return "Can't save to favorite"
        case .deleteError:
            return "Can't delete from favorite"
        }
    }
}
