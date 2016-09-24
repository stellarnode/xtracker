

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewEntryViewControllerDelegate {

    // MARK: Properties

    @IBOutlet weak var tableEntries: UITableView!
    
    var entries = Entry.loadEntries()
    var venues = Venue.loadVenues()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        

        tableEntries.dataSource = self
        tableEntries.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Methods for UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell

        let entry = entries[indexPath.row]
        cell.labelCategory.text = entry.category
        cell.labelAmount.text = String(format: "%.2f", entry.amount)

        let dateFormatter = NSDateFormatter()

        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_UK")

        if let date = entry.date {
            cell.labelDate.text = dateFormatter.stringFromDate(date)
        } else {
            let today = NSDate()
            cell.labelDate.text = dateFormatter.stringFromDate(today)
        }

        return cell
    }


    // MARK: Prepare for Segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentNewEntry" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newEntryController = navigationController.viewControllers[0] as! NewEntryViewController
            newEntryController.delegate = self
        }
    }

    // MARK: NewEntryViewControllerDelegate

    func entryCreated(entry: Entry) {
        entries.insert(entry, atIndex: 0)
        dismissViewControllerAnimated(true, completion: nil)

        tableEntries.reloadData()

        do {
            try CoreDataHelper.instance.context.save()
        } catch {
            print("saving entry failed")
        }

    }


    // MARK: UITableViewDelegate Methods

    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBAction func editButton(sender: UIBarButtonItem) {

        print(editButton.title)

        if editButton.title == "Edit" {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }

        tableEntries.editing = !tableEntries.editing

    }



//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        let category = categories[indexPath.row]
//        print("user selected \(category)")
//
//        // delegate action
//        delegate?.categorySelected(category)
//
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }



    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let indexToDelete = indexPath.row

            CoreDataHelper.instance.context.deleteObject(entries[indexToDelete])
            entries.removeAtIndex(indexToDelete)

            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            do {
                try CoreDataHelper.instance.context.save()
                print("context saved")
            } catch {
                print("saving entries context failed")
            }

            self.tableEntries.reloadData()

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


}

