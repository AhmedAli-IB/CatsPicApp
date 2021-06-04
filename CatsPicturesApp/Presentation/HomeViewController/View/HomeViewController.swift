//
//  HomeViewController.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import UIKit

// MARK: - HomeViewController
/// `HomeViewController` responsible for show a grid of cat images
///
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: HomeViewModel!
    // MARK: - Init
    //
    required init(viewModel: HomeViewModel) {
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
        setupNSNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Configuration
//
private extension HomeViewController {
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let favoriteBarButtonItem = UIBarButtonItem(title: Strings.favourite,
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(showFavorite))
        self.navigationItem.rightBarButtonItem  = favoriteBarButtonItem
    }
    /// Configure collection view
    ///
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
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
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                case .loading:
                    self.activityIndicator.startAnimating()
                case .populated:
                    self.activityIndicator.stopAnimating()
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
// MARK: - Private Handlers
//
private extension HomeViewController {
    
    @objc
    func showFavorite() {
        let favoriteVC = FavoriteViewController(viewModel: FavoriteViewModel())
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    /// Add observer on reload needed
    ///
    func setupNSNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.methodOfReceivedNotification(notification:)),
                                               name: Notification.Name.homeListReloadRequired, object: nil)
    }
    @objc
    func methodOfReceivedNotification(notification: Notification) {
        collectionView.reloadData()
    }

}
// MARK: - UICollectionViewDataSource
//
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(at: indexPath) as HomeCollectionViewCell
        cell.viewModel = viewModel.getCurrentObject(for: indexPath)
        cell.toggleFavoriteClosure = { [weak self] in
            self?.viewModel.toggleFavorite(for: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Constants.itemHeight
        let width = collectionView.frame.width / Constants.divisionWidth
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths where index.row >= viewModel.numberOfItems - Constants.prefetchingConstant {
            viewModel.viewDidLoad()
            break
        }
    }
}
// MARK: - Strings
//
private extension HomeViewController {
    enum Strings {
        static let title = "Cats"
        static let favourite = "Favorite"
    }
}
// MARK: - Constants
//
private extension HomeViewController {
    
    enum Constants {
        static let divisionWidth = CGFloat(2.0)
        static let itemHeight = CGFloat(200)
        static let prefetchingConstant = 3
    }
}
