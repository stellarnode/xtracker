

import UIKit
import CoreData


@objc(Venue)
class Venue: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var distance: Int
    @NSManaged var category: String
    @NSManaged var icon: String
    @NSManaged var id: String

    convenience init(name: String,
                     latitude: Double,
                     longitude: Double,
                     distance: Int,
                     category: String,
                     icon: String,
                     id: String) {

        let entity = NSEntityDescription.entityForName("Venue", inManagedObjectContext: CoreDataHelper.instance.context)!

        self.init(entity: entity, insertIntoManagedObjectContext: nil)

        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.category = category
        self.icon = icon
        self.id = id

    }


    static func loadVenues() -> [Venue] {
        let request = NSFetchRequest(entityName: "Venue")
        request.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]

        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Venue]
        } catch {
            return []
        }

    }


}
