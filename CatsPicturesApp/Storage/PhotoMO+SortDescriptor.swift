//
//  PhotoMO+SortDescriptor.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation

extension PhotoMO {
    static var normalSortDescriptor: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "photoUrl", ascending: true)
        ]
    }
}
