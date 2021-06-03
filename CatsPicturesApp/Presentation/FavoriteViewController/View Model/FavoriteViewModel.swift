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
    var fetchResultsController: NSFetchedResultsController<PhotoMO> = PhotoStore.shared.fetchResultsController
    
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
    
    // MARK: - Callbacks
    //
    var onReloadNeeded: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
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
    /// Get current image url based on index path
    ///
    func getCurrentImageUrl(for indexPath: IndexPath) -> String? {
        return fetchResultsController.object(at: indexPath).photoUrl
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
}
