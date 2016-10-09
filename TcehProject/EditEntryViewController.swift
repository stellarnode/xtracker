

import UIKit

protocol EditEntryViewControllerDelegate {
    func updateEntryAfterChange(entry: Entry)
}


class EditEntryViewController: UIViewController, SelectDateViewControllerDelegate, SelectCurrencyViewControllerDelegate, UITextFieldDelegate {

    var entry: Entry?
    var newDate: NSDate?
    var newCurrency: String?
    var newAmount: Double?
    var delegate: EditEntryViewControllerDelegate?
    var formatDate = DatesCustomizer.initializeFormatter()
    let formatNumber = Currency.initializeNumberFormatter()

    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelDate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelAmount.text = formatNumber(amount: entry!.amount, currencyTicker: entry!.currency!)
        labelDate.text = formatDate(date: entry!.date!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func changeAmount(sender: UIButton) {
        let alert = UIAlertController(title: "Enter amount", message: nil, preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler { textField in
            //            textField.backgroundColor = UIColor.clearColor()
            //            textField.borderStyle = .RoundedRect
            textField.placeholder = "000.00"
            textField.keyboardType = .DecimalPad
            textField.delegate = self
        }

        let okAction = UIAlertAction(title: "OK", style: .Default) { [weak self] _ in
            if let text = alert.textFields?.first?.text {
                print("user entered text: \(text)")
                self!.newAmount = Double(text)

                if let newAmount = self!.newAmount {
                    self!.labelAmount.text = self!.formatNumber(amount: newAmount, currencyTicker: self!.newCurrency ?? self!.entry!.currency!)
                } else {
                    self!.labelAmount.text = self!.formatNumber(amount: self!.entry!.amount, currencyTicker: self!.newCurrency ?? self!.entry!.currency!)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            print("action canceled")
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)

    }


    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
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


    @IBAction func changeDate(sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectDatePopOver") as! SelectDateViewController

        navigationController!.addChildViewController(popOverVC)

        popOverVC.view.frame = navigationController!.view.bounds

        navigationController!.view.addSubview(popOverVC.view)
        popOverVC.delegate = self
        popOverVC.initialDate = entry?.date

        popOverVC.didMoveToParentViewController(navigationController!)
    }

    func didSelectDate(date: NSDate) {
        newDate = date
        labelDate.text = formatDate(date: date)
    }
    

    @IBAction func changeCurrency(sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectCurrencyPopOver") as! SelectCurrencyViewController

        navigationController!.addChildViewController(popOverVC)

        popOverVC.view.frame = navigationController!.view.bounds

        navigationController!.view.addSubview(popOverVC.view)
        popOverVC.delegate = self

        popOverVC.didMoveToParentViewController(navigationController!)
    }

    func didSelectCurrency(ticker: String, fullCurrencyName: String) {
        newCurrency = ticker
        if let amount = newAmount {
            labelAmount.text = formatNumber(amount: amount, currencyTicker: newCurrency ?? entry!.currency!)
        } else {
            labelAmount.text = formatNumber(amount: entry!.amount, currencyTicker: newCurrency ?? entry!.currency!)
        }
    }


    @IBAction func saveEntry(sender: UIBarButtonItem) {

        if let newAmount = newAmount {
            entry?.amount = newAmount
        }

        if let newCurrency = newCurrency {
            entry?.currency = newCurrency
        }

        if let newDate = newDate {
            entry?.date = newDate
        }

        self.delegate?.updateEntryAfterChange(entry!)
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
