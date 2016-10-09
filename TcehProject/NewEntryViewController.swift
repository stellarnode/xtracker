
import UIKit

protocol NewEntryViewControllerDelegate {
    func entryCreated(entry: Entry)

    // func newEntryViewController(controller: NewEntryViewController, entryCreated: Entry?)
}


class NewEntryViewController: UIViewController, CategoriesViewControllerDelegate,
    VenuesViewControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, SelectCurrencyViewControllerDelegate, SelectDateViewControllerDelegate {

    @IBOutlet weak var textFieldAmount: UITextField!    
    
    @IBOutlet weak var buttonCategory: UIButton!

    @IBOutlet weak var buttonVenue: UIButton!

    @IBOutlet weak var buttonDate: UIButton!
    
    @IBOutlet weak var labelCurrency: UILabel!


    var selectedVenue: Venue?
    var selectedCategory: String?
    var selectedCurrency: String = Currency.baseCurrency
    var selectedDate: NSDate = NSDate()

    var formatDate = DatesCustomizer.initializeFormatter()

    var delegate: NewEntryViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldAmount.delegate = self

        textFieldAmount.text = ""
        textFieldAmount.placeholder = "000.00"
        textFieldAmount.becomeFirstResponder()


        labelCurrency.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.chooseCurrency))
        labelCurrency.addGestureRecognizer(tap)

        setCurrencyLabel(Currency.baseCurrency)

        buttonDate.setTitle(formatDate(date: selectedDate), forState: .Normal)
        buttonDate.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        buttonDate.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightThin)

    }


    func setCurrencyLabel(selectedCurrency: String) {

        switch selectedCurrency {

        case "RUB":
            labelCurrency.text = "₽"
            labelCurrency.font = UIFont.systemFontOfSize(48)
        case "USD":
            labelCurrency.text = "$"
            labelCurrency.font = UIFont.systemFontOfSize(48)
        case "EUR":
            labelCurrency.text = "€"
            labelCurrency.font = UIFont.systemFontOfSize(48)
        case "GBP":
            labelCurrency.text = "£"
            labelCurrency.font = UIFont.systemFontOfSize(48)
        default:
            labelCurrency.font = UIFont.systemFontOfSize(24)
            labelCurrency.text = selectedCurrency
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func chooseCurrency(sender: UILabel) {
        print("hello \(Currency.baseCurrency)")

        textFieldAmount.resignFirstResponder()

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectCurrencyPopOver") as! SelectCurrencyViewController

        navigationController!.addChildViewController(popOverVC)

        popOverVC.view.frame = navigationController!.view.bounds

        navigationController!.view.addSubview(popOverVC.view)
        popOverVC.delegate = self

        popOverVC.didMoveToParentViewController(navigationController!)

    }


    func didSelectCurrency(ticker: String, fullCurrencyName: String) {
        selectedCurrency = ticker
        setCurrencyLabel(ticker)
        textFieldAmount.becomeFirstResponder()

    }


    @IBAction func chooseDate(sender: UIButton) {
        textFieldAmount.resignFirstResponder()

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectDatePopOver") as! SelectDateViewController

        navigationController!.addChildViewController(popOverVC)

        popOverVC.view.frame = navigationController!.view.bounds

        navigationController!.view.addSubview(popOverVC.view)
        popOverVC.delegate = self

        popOverVC.didMoveToParentViewController(navigationController!)
    }

    func didSelectDate(date: NSDate) {
        selectedDate = date
        buttonDate.setTitle(formatDate(date: selectedDate), forState: .Normal)
        textFieldAmount.becomeFirstResponder()
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
        textFieldAmount.resignFirstResponder()
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func tapDone(sender: AnyObject) {
        if let text = textFieldAmount.text {
            if let amount = Double(text) {
                print("You entered \(amount)")
                // blur (stop being in focus or active)
                textFieldAmount.resignFirstResponder()

                if let venue = selectedVenue, category = selectedCategory {

                    CoreDataHelper.instance.concurrent.performBlock {
                        let concurrent = CoreDataHelper.instance.concurrent

                        concurrent.performBlock {
                            concurrent.insertObject(venue)
                            let entry = Entry(amount: amount, venue: venue, category: category, currency: self.selectedCurrency, date: self.selectedDate, context: concurrent)
                            CoreDataHelper.instance.saveConcurrent()

                            CoreDataHelper.instance.context.performBlock {
                                let mainEntry = CoreDataHelper.instance.context.objectWithID(entry.objectID) as! Entry
                                self.delegate?.entryCreated(mainEntry)
                            }

                        }
                        
                    }

//                    CoreDataHelper.instance.context.insertObject(venue)
//
//                    let entry = Entry(amount: amount, venue: venue,
//                          category: category, currency: selectedCurrency, date: selectedDate)
//
//                    delegate?.entryCreated(entry)
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
        buttonCategory.titleLabel?.font = UIFont.systemFontOfSize(24, weight: UIFontWeightThin)

        selectedCategory = category
    }

    func venuesViewController(controller: VenuesViewController, didSelectVenue venue: Venue) {
        print(venue)
        buttonVenue.setTitle(venue.name, forState: .Normal)
        buttonVenue.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        buttonVenue.titleLabel?.font = UIFont.systemFontOfSize(24, weight: UIFontWeightThin)

        selectedVenue = venue
    }

}
