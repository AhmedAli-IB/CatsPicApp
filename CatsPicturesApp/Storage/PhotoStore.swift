//
//  PhotoStore.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
import CoreData

// MARK: - PhotoStore
/// `PhotoStore` responsible for handle storage for photo model
//
class PhotoStore {
    // MARK: - Properties
    //
    static private(set) var shared = PhotoStore()
    
    lazy var persistentContainer: NSPersistentContainer = {
        guard let momURL = Bundle(for: PhotoStore.self).url(forResource: "CatsPicturesApp",
                                                            withExtension: "momd"),
              let mom = NSManagedObjectModel(contentsOf: momURL) else {
                fatalError("Cannot find Managed object model")
        }
        let container = NSPersistentContainer(name: "CatsPicturesApp",
                                              managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Returns a fetch results controller to be used to retireve the data
    var fetchResultsController: NSFetchedResultsController<PhotoMO> {
        let fetchRequest = PhotoMO.fetchRequest() as NSFetchRequest<PhotoMO>
        fetchRequest.fetchBatchSize = 30
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: persistentContainer.viewContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        return fetchResultsController
    }
    
    /// Import movies data from the JSON file to Core Data.
    /// If data is already imported to Core Data, then error callback will be called
    /// with error 'alreadyImported'
    /// - Parameter completionHandler: error callback in case of failure
    func savePhoto(photo: CatsResponse, completionHandler: ((MoviesStoreError?)->Void)?=nil) {

        persistentContainer.performBackgroundTask { (context) in
                let photoMO = PhotoMO(context: context)
                photoMO.photoUrl = photo.url
            do {
                try context.save()
                DispatchQueue.main.async {
                    completionHandler?(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler?(MoviesStoreError.saveError(error: error))
                }
            }
        }
    }
}
enum MoviesStoreError: Equatable, Error {

    case saveError(error: Error)

    static func == (lhs: MoviesStoreError, rhs: MoviesStoreError) -> Bool {
        switch (lhs, rhs) {
        case (.saveError, .saveError):
            return true
        }
    }
}
