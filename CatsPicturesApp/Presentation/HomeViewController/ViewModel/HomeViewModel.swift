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
    
    private var catsViewModels: [CatCellViewModel] = [] {
        didSet {
            self.onReloadNeeded?()
        }
    }
    
    let network = NetworkManager<CatEndPoint>()
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
    init() {
    }
    // MARK: - Public Handlers
    //
    func viewDidLoad() {
        loadCats()
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
    
    func loadCats() {
        guard pagingController.shouldLoadNextPage else { return }
            pagingController.startLoadingNextPage()
            state = .loading
            network.request(api: .getCats(page: pagingController.nextPageIndex, limit: 20)) { [weak self] (result: Result<[CatsResponse], NetworkError>) in
                guard let self = self else { return }
                switch result {
                
                case .success(let cats):
                    self.processFetchedCats(cats: cats)
                    self.state = .populated
                    self.pagingController.loadedPage()
                case .failure(let error):
                    self.state = .error
                    self.alertMessage = error.localizedDescription
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
