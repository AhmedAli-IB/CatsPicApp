//
//  PagingController.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 02/06/2021.
//

import Foundation
// MARK: - PagingController
//
class PagingController {
    // MARK: - Properties
    //
    private var totalNumberOfPages: Int = .max
    private var isLoading = false
    
    private var hasReachedLastPage: Bool {
        return nextPageIndex > totalNumberOfPages
    }
    
    /// The index of the next page to load.
    private(set) var nextPageIndex: Int = 1
    
    /// Check if client should load next page, returns false if loading is already in progress
    /// or client have already reached the last page.
    var shouldLoadNextPage: Bool {
        isLoading == false && hasReachedLastPage == false
    }
    
    /// Notify controller that you have started loading next page.
    func startLoadingNextPage() {
        isLoading = true
    }
    
    /// Notif that controller that loading page has ended with information
    /// about what's loaded
    ///
    func loadedPage() {
        nextPageIndex += 1
        isLoading = false
    }
    
    /// Notify the controller that loading has finished but no pages were loaded
    ///
    func finishedWithError() {
        isLoading = false
    }
}
