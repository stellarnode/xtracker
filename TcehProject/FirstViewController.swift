

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class FirstViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var tableEntries: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var selectedEntry: Entry?
    var editEntryVC: EditEntryViewController?

    var fetchedResultsController = NSFetchedResultsController()
    var baseCurrency = Currency.baseCurrency
    let refreshControl = UIRefreshControl()
    let formatNumber = Currency.initializeNumberFormatter()
    var formatDate = DatesCustomizer.initializeFormatter()


    // MARK: Load views

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableEntries.dataSource = self
        tableEntries.delegate = self

        refreshControl.addTarget(self, action: #selector(self.refreshEntries), forControlEvents: .ValueChanged)
        tableEntries.addSubview(refreshControl)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if baseCurrency != Currency.baseCurrency {
            baseCurrency = Currency.baseCurrency
            tableEntries.reloadData()
        }
    }


    func refreshEntries() {
        if baseCurrency != Currency.baseCurrency {
            baseCurrency = Currency.baseCurrency
            tableEntries.reloadData()
        }
        refreshControl.endRefreshing()
    }
}


// MARK: Loading data

extension FirstViewController {

    private func loadData() {
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: CoreDataHelper.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
}


// MARK: NSFetchedResultsControllerDelegate Methods

extension FirstViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableEntries.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableEntries.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableEntries.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableEntries.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let indexPath = indexPath {
                let cell = tableEntries.cellForRowAtIndexPath(indexPath) as! EntryCell
                configureCell(cell, atIndexPath: indexPath)
            }
        case .Move:
            if let indexPath = indexPath {
                tableEntries.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

            if let newIndexPath = newIndexPath {
                tableEntries.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
        }
    }

    func configureCell(cell: EntryCell, atIndexPath indexPath: NSIndexPath) {
        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry

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

        if entryCurrency != Currency.baseCurrency {
            // cell.labelAmount.text = String(format: "%.2f", entry.amount) + " \(entryCurrency)"
            cell.labelAmount.text = formatNumber(amount: entry.amount, currencyTicker: entryCurrency)
            let (url, params) = Currency.getFXRateURLandParams(entryCurrency, to: Currency.baseCurrency, date: entryDate)
            print ("\(url) \n \(params)")

            Alamofire.request(.GET, url, parameters: params).responseJSON { [weak self] response in
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let source = json["source"].string!
                    // let fxRate = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!
                    let fromCurrency = json["quotes"]["\(source)\(entryCurrency)"].double!
                    let toCurrency = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!
                    // cell.labelAmount.text = String(format: "%.2f", entry.amount * fxRate)
                    // cell.labelAmount.text = String(format: "%.2f", entry.amount / fromCurrency * toCurrency)
                    cell.labelAmount.text = self!.formatNumber(amount: entry.amount / fromCurrency * toCurrency, currencyTicker: Currency.baseCurrency)
                }
            }
        } else {
            // cell.labelAmount.text = String(format: "%.2f", entry.amount)
            cell.labelAmount.text = formatNumber(amount: entry.amount, currencyTicker: Currency.baseCurrency)
        }
    }

}


// MARK: UITableViewDataSource Methods

extension FirstViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let sections = fetchedResultsController.sections {
            selectedEntry = sections[0].objects![indexPath.row] as? Entry
            editEntryVC!.entry = selectedEntry
        }
    }
}


// MARK: UITableViewDelegate Methods

extension FirstViewController: UITableViewDelegate {

    @IBAction func editButton(sender: UIBarButtonItem) {
        print(editButton.title)

        if editButton.title == "Edit" {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }

        tableEntries.editing = !tableEntries.editing
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry

        if editingStyle == .Delete {
            CoreDataHelper.instance.context.deleteObject(entry)
            do {
                try CoreDataHelper.instance.context.save()
                tableEntries.reloadData()
            } catch let error {
                print("could not delete entry due to context saving failure - error: \(error)")
            }
        }
    }
}


// MARK: NewEntryViewController and EditEntryViewController Delegation

extension FirstViewController: NewEntryViewControllerDelegate, EditEntryViewControllerDelegate {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentNewEntry" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newEntryController = navigationController.viewControllers[0] as! NewEntryViewController
            newEntryController.delegate = self
        }

        if segue.identifier == "PresentEditEntry" {
            let editEntryController = segue.destinationViewController as! EditEntryViewController
            editEntryController.delegate = self
            editEntryVC = editEntryController
        }
    }

    func entryCreated(entry: Entry) {
//        entries.insert(entry, atIndex: 0)
        dismissViewControllerAnimated(true, completion: nil)

        tableEntries.reloadData()

        do {
            try CoreDataHelper.instance.context.save()
        } catch {
            print("saving entry failed")
        }
    }


    func updateEntryAfterChange(entry: Entry) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }

        do {
            try CoreDataHelper.instance.context.save()
        } catch {
            print("saving entry failed")
        }

        tableEntries.reloadData()

    }

}






