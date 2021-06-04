//
//  FavoriteViewController.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Properties
    //
    var viewModel: FavoriteViewModel!
    
    // MARK: - Init
    //
    required init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureViewModel()
        viewModel.viewDidLoad()
    }
}
// MARK: - Configuration
//
private extension FavoriteViewController {
    
    /// Configure appearance
    ///
    func configureAppearance() {
        configureNavigationBar()
        registerCells()
        configureCollectionView()
    }
    /// Configure view
    ///
    func configureNavigationBar() {
        self.title = Strings.title
    }
    /// Configure collection view
    ///
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    /// Register cells
    ///
    func registerCells() {
        collectionView.registerCellNib(HomeCollectionViewCell.self)
    }
    
    /// Configure view model
    ///
    func configureViewModel() {
        
        // Bind on show alert
        viewModel.showAlertClosure = { [weak self]  in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        // Bind on loading status
        //
        viewModel.updateLoadingStatus = { [weak self]  in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty:
                    self.activityIndicator.stopAnimating()
                    self.collectionView.setEmptyMessage(Strings.emptyMessage)
                case .error:
                    self.activityIndicator.stopAnimating()
                    self.collectionView.restore()
                case .loading:
                    self.activityIndicator.startAnimating()
                case .populated:
                    self.activityIndicator.stopAnimating()
                    self.collectionView.restore()
                }
            }
        }
        // Reload table view
        //
        viewModel.onReloadNeeded = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
//
extension FavoriteViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSection
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(for: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(at: indexPath) as HomeCollectionViewCell
        cell.viewModel = viewModel.createCellViewModel(for: indexPath)
        cell.toggleFavoriteClosure = { [weak self] in
            self?.viewModel.removeFromFavorite(for: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Constants.itemHeight
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
// MARK: - Strings
//
private extension FavoriteViewController {
    enum Strings {
        static let title = "Favorite 🌟"
        static let emptyMessage = "No favorite yet"
        
    }
}
// MARK: - Constants
//
private extension FavoriteViewController {
    
    enum Constants {
        static let itemHeight = CGFloat(200)
    }
}
