//
//  HomeCollectionViewCell.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var catImageView: UIImageView!
    
    // MARK: - Properties
    //
    var viewModel: CatCellViewModel? {
        didSet {
            configureCell()
        }
    }

    var toggleFavoriteClosure: (() -> Void)?
    
    // MARK: - Lifeccycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
// MARK: - IBActions
//
private extension HomeCollectionViewCell {
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        toggleFavoriteClosure?()
    }
}
// MARK: - Configuration
//
private extension HomeCollectionViewCell {
    
    /// Configure cell with data from cell view model
    ///
    func configureCell() {
        catImageView.setImage(urlString: viewModel?.imageURL, placeholder: .catPlaceHolder)
    
        viewModel?.isFavorite ?? false ? (favoriteButton.setImage(.favoritIcon, for: .normal)) : favoriteButton.setImage(.unfavoritIcon, for: .normal)
    }
}
