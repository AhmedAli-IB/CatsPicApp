//
//  FavoriteViewModel.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
import CoreData.NSFetchedResultsController
// MARK: - FavoriteViewModel
/// `FavoriteViewModel` responsible for  handling favorite list presentation 
//
class FavoriteViewModel {
    
    // MARK: - Properties
    //
    lazy var fetchResultsController: NSFetchedResultsController<PhotoMO> = PhotoStore.shared.fetchResultsController
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    let photoUseCase: PhotoUseCaseType
    
    // MARK: - Callbacks
    //
    var onReloadNeeded: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
    // MARK: - Init
    //
    init(photoUseCase: PhotoUseCaseType = PhotoUseCase()) {
        self.photoUseCase = photoUseCase
    }
    
    // MARK: - Public Handlers
    //
    func viewDidLoad() {
        fetchFavoritePhotosFromDB()
    }
    /// number of sections
    ///
    var numberOfSection: Int {
        let count = fetchResultsController.sections?.count ?? 1
        if count == .zero {
            self.state = .empty
        }
        return count
    }
    /// number of items for section
    ///
    func  numberOfItems(for section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    /// Create favorite cell view model with defualt value for favorite  = true
    ///
    func createCellViewModel(for indexPath: IndexPath) -> CatCellViewModel {
        return CatCellViewModel(imageURL: fetchResultsController.object(at: indexPath).photoUrl ?? "", isFavorite: true)
    }
    
    /// Delete item to core data
    /// - Parameters:
    ///   - indexPath: current item indexPath
    ///   - photo: item to be deleted
    func removeFromFavorite(for indexPath: IndexPath,
                            onCompletion: ((PhotosStoreError?) -> Void)? = nil) {
        let photo = fetchResultsController.object(at: indexPath)
        photoUseCase.removeFromFavorite(photo.photoId ?? "0") { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil  else {
                self.alertMessage = error?.localizedDescription
                onCompletion?(error)
                return
            }
            self.fetchFavoritePhotosFromDB()
            self.reloadHomeView()
            onCompletion?(nil)
        }
    }
    
}
// MARK: - Private Handlers
//
private extension FavoriteViewModel {
    
    func fetchFavoritePhotosFromDB() {
        state = .loading
        do {
            try fetchResultsController.performFetch()
            state = .populated
            onReloadNeeded?()
        } catch {
            state = .error
            alertMessage = error.localizedDescription
        }
    }
    
    /// Relaod home collection view when remove item from favorite..
    ///
    func reloadHomeView() {
        NotificationCenter.default.post(name: Notification.Name.homeListReloadRequired, object: nil)
    }
}
