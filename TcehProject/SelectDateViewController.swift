

import UIKit


protocol SelectDateViewControllerDelegate {

    func didSelectDate(date: NSDate)
    
}


class SelectDateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: SelectDateViewControllerDelegate?
    var initialDate: NSDate?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        datePicker.datePickerMode = .Date
        if let date = initialDate {
            datePicker.setDate(date, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    @IBAction func didSelectDate(sender: UIButton) {
        let date = datePicker.date
        delegate?.didSelectDate(date)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()

    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
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
