

import Foundation

class Categories {
    
    var defaultCategories = [
        "Automobile : Gasoline",
        "Automobile : Maintenance",
        "Automobile : Parking",
        "Transportation : Taxi & Other",
        "Bank & Broker Service Charges",
        "Bills : Cellular / Telephone",
        "Bills : Credit Card Payments",
        "Bills : Online / Internet Service",
        "Bills : Utilities / Rent",
        "Bills : Electricity",
        "Bills : Water / Sewer / Trash",
        "Cash Withdrawal : [all]",
        "Clothing : [all]",
        "Education : Books",
        "Education : Tuition & Courses",
        "Education : [all other]",
        "Equipment : [all]",
        "Food : Day Meals",
        "Food : Eating & Dining Out",
        "Food : Groceries",
        "Gifts : Work & Friends",
        "Gifts : Family",
        "Gifts : [all other]",
        "Healthcare : Prescriptions",
        "Healthcare : Treatment",
        "Healthcare : [all other]",
        "Household : Laundry & Cleaning",
        "Household : [all other]",
        "Insurance : Automobile",
        "Insurance : Life & Medical",
        "Insurance : Real Estate",
        "Insurance : [all other]",
        "Investments : Real Estate",
        "Investments : Retirement",
        "Investments : Stocks & Commodities",
        "Investments : [all other]",
        "Job Expense : Non-Reimbursed",
        "Job Expense : Reimbursed",
        "Leisure : Books & Magazines",
        "Leisure : Cultural Events",
        "Leisure : Movies & Video Rentals",
        "Leisure : Games / CDs / Toys",
        "Leisure : [all other]",
        "Personal Care : [all]",
        "Taxes : Federal Income Tax",
        "Taxes : Real Estate",
        "Taxes : [all other]",
        "Travel : Air Fare & Lodging",
        "Vacation : [all]",
        "All Other Expenses"
    ]

    var userDefinedCategories = [String]()

    // local storage option
    // var storage = NSUserDefaults.standardUserDefaults()

    // icloud storage option with local replica
    var storage = NSUbiquitousKeyValueStore.defaultStore()

    static let categoryManager = Categories()

    init() {
        userDefinedCategories = defaultCategories

        if let categories = storage.objectForKey("userCategories") {
            userDefinedCategories = categories as! [String]
        } else {
            storage.setObject(userDefinedCategories, forKey: "userCategories")
        }
    }

    func loadCategories() -> [String] {

        if let categories = storage.objectForKey("userCategories") {
            userDefinedCategories = categories as! [String]
            return userDefinedCategories
        } else {
            return defaultCategories
        }

    }


    func saveCategories(categories: [String]) {
        storage.setObject(categories, forKey: "userCategories")
        storage.synchronize()
    }


}