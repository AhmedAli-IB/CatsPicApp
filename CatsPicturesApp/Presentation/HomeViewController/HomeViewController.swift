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
    
    // MARK: - Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Configuration
//
private extension HomeViewController {
    
    /// Configure appearance
    ///
    func configureAppearance() {
        configureNavigationBar()
        configureViewModel()
        registerCells()
        configureCollectionView()
    }
    /// Configure view
    ///
    func configureNavigationBar() {
        self.title = Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    /// Configure view model
    ///
    func configureViewModel() {
        
    }
    /// Configure collection view
    ///
    func configureCollectionView() {

    }
    /// Register cells
    ///
    func registerCells() {
    }
}

// MARK: - Strings
//
private extension HomeViewController {
    enum Strings {
        static let title = "Cats Gallery"
    }
}
