//
//  NSObject+Helpers.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation

/// NSObject: Helper Methods
///
extension NSObject {
    
    /// Returns the receiver's classname as a string, not including the namespace.
    ///
    class var classNameWithoutNamespaces: String {
        return String(describing: self)
    }
    
}
