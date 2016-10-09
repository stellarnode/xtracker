

import UIKit

protocol CategoriesViewControllerDelegate {
    // orthodox naming
    // func categoriesViewController(controller: CategoriesViewController, didSelectCategory category: String)
    func categorySelected(category: String)
}



class CategoriesViewController: UITableViewController {

    // MARK: Properties

    var categories = Categories.categoryManager.loadCategories()

    var delegate: CategoriesViewControllerDelegate?


    // MARK: Actions

    @IBAction func tapCancel(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func tapAdd(sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler { textField in
//            textField.backgroundColor = UIColor.clearColor()
//            textField.borderStyle = .RoundedRect
            textField.placeholder = "Category name..."
        }

        let okAction = UIAlertAction(title: "OK", style: .Default) { _ in
            if let text = alert.textFields?.first?.text {
                print("user entered text: \(text)")
                self.categories.append(text)
                Categories.categoryManager.saveCategories(self.categories)
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            print("action canceled")
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)

    }


    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBAction func tapRearrange(sender: UIBarButtonItem) {

        print(editButton.title)

        if editButton.title == "Edit" {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }

        self.editing = !self.editing

    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell

        // Configure the cell...

        let category = categories[indexPath.row]
        cell.labelCategory.text = category

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let category = categories[indexPath.row]
        print("user selected \(category)")

        // delegate action
        delegate?.categorySelected(category)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }



    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let indexToDelete = indexPath.row
            categories.removeAtIndex(indexToDelete)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            Categories.categoryManager.saveCategories(categories)
            self.tableView.reloadData()

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }



    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        let itemToMove = categories[fromIndexPath.row]
        categories.removeAtIndex(fromIndexPath.row)
        categories.insert(itemToMove, atIndex: toIndexPath.row)

        Categories.categoryManager.saveCategories(categories)

    }



    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
