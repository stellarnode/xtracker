//
//  TodayViewController.swift
//  TcehWidget
//
//  Created by Yaroslav Smirnov on 06/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Alamofire
import SwiftyJSON


class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableEntries: UITableView!
    let entries = Entry.loadEntries(3)
    var fetchedResultsController = NSFetchedResultsController()
    let formatNumber = Currency.initializeNumberFormatter()
    var formatDate = DatesCustomizer.initializeFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableEntries.dataSource = self
        tableEntries.delegate = self
        print(entries)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string: "tceh://newentry")!
        extensionContext?.openURL(url, completionHandler: nil)
    }


    func configureCell(cell: EntryCell, atIndexPath indexPath: NSIndexPath) {
        let entry = entries[indexPath.row]

        cell.labelAmount.textColor = UIColor.whiteColor()
        cell.labelCategory.textColor = UIColor.whiteColor()
        cell.labelDate.textColor = UIColor.whiteColor()

        var entryDate = NSDate()
        let entryCurrency = entry.currency ?? "USD"

        if let date = entry.date {
            cell.labelDate.text = formatDate(date: date)
            entryDate = date
        } else {
            let today = NSDate()
            cell.labelDate.text = formatDate(date: today)
            entryDate = today
        }

        cell.labelCategory.text = entry.category
        cell.labelAmount.text = formatNumber(amount: entry.amount, currencyTicker: Currency.baseCurrency)

//        if entryCurrency != Currency.baseCurrency {
//            // cell.labelAmount.text = String(format: "%.2f", entry.amount) + " \(entryCurrency)"
//            cell.labelAmount.text = formatNumber(amount: entry.amount, currencyTicker: entryCurrency)
//            let (url, params) = Currency.getFXRateURLandParams(entryCurrency, to: Currency.baseCurrency, date: entryDate)
//            print ("\(url) \n \(params)")
//
//            Alamofire.request(.GET, url, parameters: params).responseJSON { [weak self] response in
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    print(json)
//                    let source = json["source"].string!
//                    // let fxRate = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!
//                    let fromCurrency = json["quotes"]["\(source)\(entryCurrency)"].double!
//                    let toCurrency = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!
//                    // cell.labelAmount.text = String(format: "%.2f", entry.amount * fxRate)
//                    // cell.labelAmount.text = String(format: "%.2f", entry.amount / fromCurrency * toCurrency)
//                    cell.labelAmount.text = self!.formatNumber(amount: entry.amount / fromCurrency * toCurrency, currencyTicker: Currency.baseCurrency)
//                }
//            }
//        } else {
//            // cell.labelAmount.text = String(format: "%.2f", entry.amount)
//            cell.labelAmount.text = formatNumber(amount: entry.amount, currencyTicker: Currency.baseCurrency)
//        }
    }
    

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
