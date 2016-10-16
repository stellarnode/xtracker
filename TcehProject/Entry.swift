

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
    var amountConvertedToBaseCurrency: Double?

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(amount: Double, venue: Venue, category: String, currency: String, date: NSDate, context: NSManagedObjectContext) {

        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: context)!

        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.amount = amount
        self.venue = venue
        self.category = category
        self.date = date
        self.currency = currency
        self.createdAt = NSDate()
    }

    convenience init(amount: Double, venue: Venue, category: String, context: NSManagedObjectContext) {
        self.init(amount: amount, venue: venue, category: category, currency: Currency.baseCurrency, date: NSDate(), context: context)
    }

    convenience init(amount: Double, venue: Venue, category: String, currency: String, context: NSManagedObjectContext) {
        self.init(amount: amount, venue: venue, category: category, currency: currency, date: NSDate(), context: context)
    }


    class func loadEntries(limit: Int? = nil) -> [Entry] {
        let request = NSFetchRequest(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        if let limit = limit {
            request.fetchLimit = limit
        }

        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Entry]
        } catch {
            return []
        }
    }

    class func loadPastTwoMonths() -> [Entry] {
        let request = NSFetchRequest(entityName: "Entry")

        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = -2

        var startOfPastTwoMonths = calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])
        startOfPastTwoMonths = calendar.dateBySettingUnit(.Day, value: 1, ofDate: startOfPastTwoMonths!, options: [])
        startOfPastTwoMonths = calendar.startOfDayForDate(startOfPastTwoMonths!)

        request.predicate = NSPredicate(format: "date >= %@", argumentArray: [startOfPastTwoMonths!])

        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Entry]
        } catch {
            return []
        }
    }

}
