//
//  UICollectionView+Helpers.swift
//  DRC
//
//  Created by Ahmed Ali on 27/05/2021.
//

import UIKit

extension UICollectionView {
    /// register cell with generics
    ///
    func registerCellNib<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        let nibName = reuseIdentifier ?? T.classNameWithoutNamespaces
        self.register(T.loadNib(), forCellWithReuseIdentifier: nibName)
    }
    
    /// dequeue cell with generics
    ///
    func dequeue<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
        else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }
    /// handle empty state in collection view
    ///
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    /// show collection view
    ///
    func restore() {
        self.backgroundView = nil
    }
    
}
