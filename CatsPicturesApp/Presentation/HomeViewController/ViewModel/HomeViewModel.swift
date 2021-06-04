//
//  HomeViewModel.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
// MARK: - HomeViewModel
/// `HomeViewModel` responsible for handling home list presentation layer
//
class HomeViewModel {
    
    // MARK: - Properties
    //
    private var cats: [CatsResponse] = [] {
        didSet {
            self.onReloadNeeded?()
        }
    }
    let pagingController = PagingController()
    let photoUseCase: PhotoUseCaseType
    
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
    
    // MARK: - Init
    //
    init(photoUseCase: PhotoUseCaseType = PhotoUseCase()) {
        self.photoUseCase = photoUseCase
    }
    // MARK: - Public Handlers
    //
    func viewDidLoad() {
        loadPhotoCats()
    }
    /// number of items
    ///
    var numberOfItems: Int {
        return cats.count
    }
    /// Get current object based on index path
    ///
    func getCurrentObject(for indexPath: IndexPath) -> CatCellViewModel {
        return createCellViewModel(cats[indexPath.item])
    }
    /// Switch between favorite state
    ///
    func toggleFavorite(for indexPath: IndexPath) {
        let item = cats[indexPath.item]
        photoUseCase.isExist(cats[indexPath.item].id ?? "0")  == false ? saveToFavorite(item) : removeFromFavorite(item.id)
    }
    /// Save item to core data
    /// - Parameters:
    ///   - photo: item to be favorite
    func saveToFavorite(_ photo: CatsResponse, onCompletion: ((PhotosStoreError?) -> Void)? = nil) {
        photoUseCase.saveToFavorite(photo) { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil  else {
                self.alertMessage = error?.localizedDescription
                onCompletion?(error)
                return
            }
            onCompletion?(nil)
            self.onReloadNeeded?()
        }
    }
    /// Delete item to core data
    /// - Parameters:
    ///   - photoId: item id to be deleted
    func removeFromFavorite(_ photoId: String?,
                            onCompletion: ((PhotosStoreError?) -> Void)? = nil) {
        guard let id = photoId else { return }
        photoUseCase.removeFromFavorite(id) { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil  else {
                self.alertMessage = error?.localizedDescription
                onCompletion?(error)
                return
            }
            onCompletion?(nil)
            self.onReloadNeeded?()
        }
    }
}

// MARK: - Private Handlers
//
private extension HomeViewModel {
    
    /// Load photo cats from remote api
    ///
    func loadPhotoCats() {
        guard pagingController.shouldLoadNextPage else { return }
        pagingController.startLoadingNextPage()
        state = .loading
        photoUseCase.getRandomPhotos(page: pagingController.nextPageIndex, limit: Constants.pageSize) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let cats):
                self.cats.append(contentsOf: cats)
                self.state = .populated
                self.pagingController.loadedPage()
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.description
                self.pagingController.finishedWithError()
            }
        }
    }
    
    /// Create cell view model
    ///
    func createCellViewModel(_ cat: CatsResponse ) -> CatCellViewModel {
        return CatCellViewModel(imageURL: cat.url ?? "", isFavorite: photoUseCase.isExist(cat.id ?? "0"))
    }
}
// MARK: - Constants
private extension HomeViewModel {
    
    enum Constants {
        // scrolling page size
        static let pageSize = 20
    }
}
