

import UIKit

class WelcomeViewController: UIViewController, SelectCurrencyViewControllerDelegate {


    @IBOutlet weak var currencyStatus: UITextView!

    var activeCurrencyIndex = 0

    var currencies: [String] = Currency.manager.list


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        currencies = Currency.manager.list

    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activeCurrencyIndex = Currency.baseCurrencyFullNameIndex

        currencyStatus.text = "\(currencies[activeCurrencyIndex].uppercaseString) \n is currently set as your base currency."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    @IBAction func selectNewBaseCurrencyButton(sender: UIButton) {

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectCurrencyPopOver") as! SelectCurrencyViewController

        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.delegate = self

        popOverVC.didMoveToParentViewController(self)

    }


    func didSelectCurrency(ticker: String, fullCurrencyName: String) {
        if ticker == ticker.uppercaseString {
            Currency.baseCurrency = ticker
            Currency.userDefined = true

            currencyStatus.text = "\(fullCurrencyName.uppercaseString) \n" +
            "is set as your base currency."
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
