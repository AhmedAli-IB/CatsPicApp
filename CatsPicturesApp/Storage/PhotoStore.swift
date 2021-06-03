//
//  PhotoStore.swift
//  CatsPicturesApp
//
//  Created by Ahmed Ali on 03/06/2021.
//

import Foundation
import CoreData

// MARK: - PhotoStore
/// `PhotoStore` responsible for handle storage for  favorite photos 
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
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Returns a fetch results controller to be used to retireve the data
    ///
    var fetchResultsController: NSFetchedResultsController<PhotoMO> {
        let fetchRequest = PhotoMO.fetchRequest() as NSFetchRequest<PhotoMO>
        fetchRequest.fetchBatchSize = 30
        fetchRequest.sortDescriptors = PhotoMO.normalSortDescriptor

        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: persistentContainer.viewContext,
                                                                sectionNameKeyPath: "photoUrl",
                                                                cacheName: nil)
        return fetchResultsController
    }
    
    /// Save favorite photo to core data
    /// - Parameters:
    ///   - photo: item to save to core data
    ///   - completionHandler: error callback in case of failure
    ///
    func savePhoto(photo: CatsResponse, completionHandler: ((PhotosStoreError?)->Void)?=nil) {
        
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
                    completionHandler?(PhotosStoreError.saveError(error: error))
                }
            }
        }
    }
    
    /// Delete favorite photo from core data
    /// - Parameters:
    ///   - photo: item to delete from core data
    ///   - completionHandler: error callback in case of failure
    ///
    func deletePhoto(photo: CatsResponse, completionHandler: ((PhotosStoreError?)->Void)?=nil) {
        
        persistentContainer.performBackgroundTask { (context) in
            
            let request = PhotoMO.fetchRequest() as NSFetchRequest<PhotoMO>
            guard let photoUrl = photo.url else { return }
            request.predicate = NSPredicate(format: "photoUrl = %@", photoUrl)
            
            do {
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
                DispatchQueue.main.async {
                    completionHandler?(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler?(PhotosStoreError.deleteError(error: error))
                }
            }
        }
    }
    /// remove all favorite
    ///
    func clear() {
        persistentContainer.viewContext.performAndWait {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: PhotoMO.fetchRequest())
            do {
              try persistentContainer.viewContext.execute(batchDeleteRequest)
            } catch {
                
            }
        }
    }

}
