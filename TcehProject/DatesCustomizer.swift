

import Foundation


class DatesCustomizer {

    static func initializeFormatter() -> (date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()

        dateFormatter.dateStyle = .ShortStyle

        // UNCOMMENT TO USE LOCALE OF THE USER
        var currentLocale = NSLocale.currentLocale().localeIdentifier
        print("current locale for data: \(currentLocale)")
        dateFormatter.locale = NSLocale(localeIdentifier: currentLocale)

        // USE U.K. LOCALE FOR DATES
        // dateFormatter.locale = NSLocale(localeIdentifier: "en_UK")


        func formatDate(date: NSDate) -> String {
            return dateFormatter.stringFromDate(date)
        }

        return formatDate

    }

}