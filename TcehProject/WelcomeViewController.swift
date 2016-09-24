

import UIKit

class WelcomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var currencyPicker: UIPickerView!

    @IBOutlet weak var currencyStatus: UITextView!

    var currencies: [String] = Currency.manager.list {

        didSet {
            currencyPicker.reloadAllComponents()
        }

    }


    override func viewWillAppear(animated: Bool) {
        currencies = Currency.manager.list
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.dataSource = self
        currencyPicker.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currencies[row]
    }


    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selection = currencies[row]
        let range = selection.startIndex.advancedBy(0)...selection.startIndex.advancedBy(2)
        let ticker = selection.substringWithRange(range)

        if ticker == ticker.uppercaseString {
            Currency.baseCurrency = selection
            Currency.userDefined = true

            currencyStatus.text = "\(selection.uppercaseString) \n" +
                "will now be used as your base currency."
        }

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
