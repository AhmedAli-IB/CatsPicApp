//
//  HomeViewModel.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

// MARK: - HomeViewModel
/// `HomeViewModel` responsible handling home presentation layer
//
class  HomeViewModel {
    
    // MARK: - Properties
    //
    private var cats: [CatsResponse] = []
    let pagingController = PagingController()
    let photoUseCase: PhotoUseCaseType

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
    
    func toggleFavorite(for indexPath: IndexPath) {
        catsViewModels[indexPath.item].isFavorite = !catsViewModels[indexPath.item].isFavorite
        onReloadNeeded?()
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
