

import UIKit
import CoreData

@objc(Entry)
class Entry: NSManagedObject {
    @NSManaged var amount: Double
    @NSManaged var venue: Venue
    @NSManaged var category: String
    @NSManaged var currency: String?
    @NSManaged var date: NSDate?
    @NSManaged var createdAt: NSDate

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(amount: Double, venue: Venue, category: String, currency: String, date: NSDate) {

        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: CoreDataHelper.instance.context)!

        super.init(entity: entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)

        self.amount = amount
        self.venue = venue
        self.category = category
        self.date = date
        self.currency = currency
        self.createdAt = NSDate()
    }

    convenience init(amount: Double, venue: Venue, category: String) {
        self.init(amount: amount, venue: venue, category: category, currency: Currency.baseCurrency, date: NSDate())
    }


    class func loadEntries() -> [Entry] {
        let request = NSFetchRequest(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Entry]
        } catch {
            return []
        }


    }

}
