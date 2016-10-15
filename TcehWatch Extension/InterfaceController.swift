//
//  InterfaceController.swift
//  TcehWatch Extension
//
//  Created by Yaroslav Smirnov on 10/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var tableEntries: WKInterfaceTable!

    var entries = [[String: AnyObject]]()

    deinit {
        WatchHelper.instance.removeObserver(self, forKeyPath: "entries")
    }


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        WatchHelper.instance.addObserver(self, forKeyPath: "entries", options: .New, context: nil)

        if let entries = WatchHelper.cache.objectForKey("cachedEntries") {
            self.entries = entries as! [[String: AnyObject]]
        } else {
            self.entries = []
        }

        reloadEntries()

    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        if keyPath == "entries" {
            self.entries = WatchHelper.instance.entries
            reloadEntries()
        }
    }

    func reloadEntries() {

        tableEntries.setNumberOfRows(entries.count, withRowType: "EntryRow")

        for i in 0..<entries.count {
            let entry = entries[i]
            let category = entry["category"] as! String
            let amount = entry["amount"] as! Double

            let row = tableEntries.rowControllerAtIndex(i) as! EntryRow
            row.labelCategory.setText(category)
            row.labelAmount.setText(String(amount))
        }

    }


    @IBAction func newEntryMenuItemTapped() {
        presentControllerWithName("NewEntryInterfaceController", context: nil)
    }



    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
