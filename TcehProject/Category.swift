//
//  Category.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 10/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit
import CloudKit

class Category: NSObject {

    let name: String
    let imageURL: String?

    init(name: String, imageURL: String? = nil) {
        self.name = name
        self.imageURL = imageURL
    }

    class func loadCategories(complition: ([Category] -> Void)) {
        let container = CKContainer(identifier: "iCloud.com.tceh.app")
        let database = container.publicCloudDatabase
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
        database.performQuery(query, inZoneWithID: nil) { records, error in
            if let error = error {
                print("loading error: \(error)")
            }

            guard let records = records else { return }

            var categories: [Category] = []

            for record in records {
                let name = record["name"] as! String
                let imageURL = record["imageURL"] as? String
                let category = Category(name: name, imageURL: imageURL)
                categories.append(category)
            }

            complition(categories)
        }
    }

    class func saveCategory(name: String) {
        let container = CKContainer(identifier: "iCloud.com.tceh.app")
        let database = container.publicCloudDatabase

        let record = CKRecord(recordType: "Category")
        record["name"] = name

        database.saveRecord(record) { record, error in
            if let error = error {
                print("save record error: \(error)")
            }
        }
    }

}
