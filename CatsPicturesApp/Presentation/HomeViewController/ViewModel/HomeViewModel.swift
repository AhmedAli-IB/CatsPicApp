//
//  HomeViewModel.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
// MARK: - HomeViewModel
/// `HomeViewModel` responsible for handling home presentation layer
//
class HomeViewModel {
    
    // MARK: - Properties
    //
    private var cats: [CatsResponse] = []
    let pagingController = PagingController()
    let photoUseCase: PhotoUseCaseType
//    lazy var fetchResultsController: NSFetchedResultsController<PhotoMO> = PhotoStore.shared.fetchResultsController

    private var catsViewModels: [CatCellViewModel] = [] {
        didSet {
            self.onReloadNeeded?()
        }
    }
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
        return catsViewModels.count
    }
    /// Get current object based on index path
    ///
    func getCurrentObject(for indexPath: IndexPath) -> CatCellViewModel {
        return catsViewModels[indexPath.row]
    }
    /// Switch between favorite state
    ///
    func toggleFavorite(for indexPath: IndexPath) {
        let item = cats[indexPath.item]
        catsViewModels[indexPath.item].isFavorite  == false ? saveToFavorite(for: indexPath, item) : removeFromFavprite(for: indexPath, item)

    }
    /// Save item to core data
    /// - Parameters:
    ///   - indexPath: current item indexPath
    ///   - photo: item to be favorite
    func saveToFavorite(for indexPath: IndexPath, _ photo: CatsResponse) {
    
        photoUseCase.saveToFavorite(photo) { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil  else {
                self.alertMessage = error?.localizedDescription
                return
            }
            self.catsViewModels[indexPath.item].isFavorite = !self.catsViewModels[indexPath.item].isFavorite
            self.onReloadNeeded?()
        }
    }
    /// Delete item to core data
    /// - Parameters:
    ///   - indexPath: current item indexPath
    ///   - photo: item to be deleted
    func removeFromFavprite(for indexPath: IndexPath, _ photo: CatsResponse) {
        photoUseCase.removeFromFavorite(photo) { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil  else {
                self.alertMessage = error?.localizedDescription
                return
            }
            self.catsViewModels[indexPath.item].isFavorite = !self.catsViewModels[indexPath.item].isFavorite
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
                self.processFetchedCats(cats: cats)
                self.state = .populated
                self.pagingController.loadedPage()
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.description
                self.pagingController.finishedWithError()
            }
        }
    }
    
    /// Create Cell View Model with image url and isFavorite equal false by default
    ///
    func createCellViewModel(_ cat: CatsResponse ) -> CatCellViewModel {
        return CatCellViewModel(imageURL: cat.url ?? "")
    }
    /// Process fetched cats
    ///
    func processFetchedCats(cats: [CatsResponse] ) {
        self.cats.append(contentsOf: cats)
        var vms = [CatCellViewModel]()
        for cat in cats {
            vms.append( createCellViewModel(cat) )
        }
        self.catsViewModels.append(contentsOf: vms)
    }
}
// MARK: - Constants
private extension HomeViewModel {
    
    enum Constants {
        static let pageSize = 20
    }
}
