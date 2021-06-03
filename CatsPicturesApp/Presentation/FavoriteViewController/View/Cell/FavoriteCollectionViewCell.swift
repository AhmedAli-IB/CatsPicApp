//
//  FavoriteCollectionViewCell.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    //
    @IBOutlet private  weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    //
    var viewModel: String? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - Lifecycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
// MARK: - Configuration
//
private extension FavoriteCollectionViewCell {
    
    /// Configure cell with data from cell view model
    ///
    func configureCell() {
        photoImageView.setImage(urlString: viewModel, placeholder: .catPlaceHolder)
    }
}
