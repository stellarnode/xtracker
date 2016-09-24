
import UIKit

protocol NewEntryViewControllerDelegate {
    func entryCreated(entry: Entry)

    // func newEntryViewController(controller: NewEntryViewController, entryCreated: Entry?)
}


class NewEntryViewController: UIViewController, CategoriesViewControllerDelegate,
    VenuesViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var textFieldAmount: UITextField!    
    
    @IBOutlet weak var buttonCategory: UIButton!

    @IBOutlet weak var buttonVenue: UIButton!

    var selectedVenue: Venue?
    var selectedCategory: String?

    var delegate: NewEntryViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldAmount.delegate = self

        textFieldAmount.text = ""
        textFieldAmount.placeholder = "000.00"
        textFieldAmount.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {

        let text = (textFieldAmount.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let pattern = "(\\d*)?(\\.?\\d{0,2})?"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.numberOfMatchesInString(text,
                            options: [], range: NSRange(location: 0, length: text.characters.count))

        print(matches)

        if (matches < 3 && matches > 0) || text == ""  {
            return true
        } else {
            return false
        }

    }


    @IBAction func tapClose(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func tapDone(sender: AnyObject) {
        if let text = textFieldAmount.text {
            if let amount = Double(text) {
                print("You entered \(amount)")
                // blur (stop being in focus or active)
                textFieldAmount.resignFirstResponder()

                if let venue = selectedVenue, category = selectedCategory {
                    CoreDataHelper.instance.context.insertObject(venue)
                    let entry = Entry(amount: amount, venue: venue, category: category)
                    delegate?.entryCreated(entry)
                }

            }
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if segue.identifier == "PresentCategories" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let categoriesController = navigationController.viewControllers[0] as! CategoriesViewController
            categoriesController.delegate = self
        }

        if segue.identifier == "PresentVenues" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let venuesController = navigationController.viewControllers[0] as! VenuesViewController
            venuesController.delegate = self
        }

    }

    func categorySelected(category: String) {
        print("I know that you selected \(category)")

        // can be written in full
        // presentedViewController?.dismissViewControllerAnimated(true, completion: nil)

        // here is a short version
        dismissViewControllerAnimated(true, completion: nil)

        buttonCategory.setTitle(category, forState: .Normal)
        buttonCategory.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        buttonCategory.titleLabel?.font = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)

        selectedCategory = category
    }

    func venuesViewController(controller: VenuesViewController, didSelectVenue venue: Venue) {
        print(venue)
        buttonVenue.setTitle(venue.name, forState: .Normal)
        buttonVenue.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        buttonVenue.titleLabel?.font = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)

        selectedVenue = venue
    }

}
