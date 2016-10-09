

import UIKit


protocol SelectCurrencyViewControllerDelegate {

    func didSelectCurrency(ticker: String, fullCurrencyName: String)

}


class SelectCurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {


    @IBOutlet weak var currencyPicker: UIPickerView!

    var delegate: SelectCurrencyViewControllerDelegate?

    var activeCurrencyIndex = 0

    var currencies: [String] = Currency.manager.list {

        didSet {
            currencyPicker.reloadAllComponents()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)

        currencyPicker.dataSource = self
        currencyPicker.delegate = self

        activeCurrencyIndex = Currency.baseCurrencyFullNameIndex
        currencyPicker.selectRow(activeCurrencyIndex, inComponent: 0, animated: true)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        currencies = Currency.manager.list

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


//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selection = currencies[row]
//        let range = selection.startIndex.advancedBy(0)...selection.startIndex.advancedBy(2)
//        let ticker = selection.substringWithRange(range)
//
//        if ticker == ticker.uppercaseString {
//            Currency.baseCurrency = ticker
//            Currency.userDefined = true
//
//        }
//        
//    }


    
    @IBAction func didSelectCurrency(sender: UIBarButtonItem) {

        let row = currencyPicker.selectedRowInComponent(0)
        let selection = currencies[row]
        let range = selection.startIndex.advancedBy(0)...selection.startIndex.advancedBy(2)
        let ticker = selection.substringWithRange(range)

        print(ticker)

        self.delegate?.didSelectCurrency(ticker, fullCurrencyName: selection)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
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
