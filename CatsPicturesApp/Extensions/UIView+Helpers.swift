//
//  UIView+Helpers.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import UIKit
extension UIView {
    /// Returns the Nib associated with the received: It's filename is expected to match the Class Name
    ///
    class func loadNib() -> UINib {
        return UINib(nibName: classNameWithoutNamespaces, bundle: nil)
    }
}
