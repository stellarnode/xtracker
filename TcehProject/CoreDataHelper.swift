

import UIKit
import CoreData


class CoreDataHelper: NSObject {

    let model: NSManagedObjectModel
    let coordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext
    let concurrent: NSManagedObjectContext

    static let instance = CoreDataHelper()

    private override init() {
        let fileManager = NSFileManager.defaultManager()
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        self.model = NSManagedObjectModel(contentsOfURL: modelURL)!
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        // use the following line to only use one app target
        // let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let docsURL = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.com.tceh.app")!
        let storeURL = docsURL.URLByAppendingPathComponent("store.sqlite")
        print("path to DB on disk: \(storeURL.path)")


        // To enable storage in iCloud add also:
        // NSPersistentStoreUbiquitousContentNameKey: "CloudStore"
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]

        do {
            try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            print("Failed to add persistent store with type")
        }

        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.coordinator

        self.concurrent = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.concurrent.persistentStoreCoordinator = self.coordinator

        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self,
                     selector: #selector(self.concurrentDidSave(_:)),
                     name: NSManagedObjectContextDidSaveNotification,
                     object: concurrent)
    }

    func concurrentDidSave(notification: NSNotification) {
        context.performBlock {
            if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] {
                for obj in updated {
                    self.context.objectWithID(obj.objectID).willAccessValueForKey(nil)
                }
            }

            self.context.mergeChangesFromContextDidSaveNotification(notification)
        }
    }


    func saveMain() {

        do {
            try context.save()
        } catch let error {
            print("main save context error: \(error)")
        }
    }


    func saveConcurrent() {
        do {
            try concurrent.save()
        } catch let error {
            print("concurrent save context error: \(error)")
        }
    }

}
