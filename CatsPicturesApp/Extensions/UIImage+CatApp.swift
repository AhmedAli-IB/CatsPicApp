//
//  UIImage+CatApp.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import UIKit
// MARK: - UIImage + App
//
extension UIImage {
    
    // swiftlint:disable all
    static var catPlaceHolder: UIImage {
        return UIImage(named: "placeholder")!
    }
    
    static var favoritIcon: UIImage {
        return UIImage(named: "favorite-icon")!
    }
    
    static var unfavoritIcon: UIImage {
        return UIImage(named: "unfavorite-icon")!
    }
}
