

import UIKit
import CoreData


class CoreDataHelper: NSObject {

    let model: NSManagedObjectModel
    let coordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext

    static let instance = CoreDataHelper()

    private override init() {
        let fileManager = NSFileManager.defaultManager()
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        self.model = NSManagedObjectModel(contentsOfURL: modelURL)!
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let storeURL = docsURL.URLByAppendingPathComponent("store.sqlite")
        print("path to DB on disk: \(storeURL.path)")

        do {
            try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            print("Failed to add persistent store with type")
        }

        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.coordinator
    }

}
