//
//  NewEntryInterfaceController.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 15/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import WatchKit
import Foundation


class NewEntryInterfaceController: WKInterfaceController {


    @IBOutlet var currencyLabel: WKInterfaceLabel!
    @IBOutlet var amountLabel: WKInterfaceLabel!
    @IBOutlet var amountSlider: WKInterfaceSlider!

    var amount = 0.0

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        print("hello from new entry interface controller")
    }


    @IBAction func amountSliderDidChange(value: Float) {
        amountLabel.setText("\(value)")
        amount = Double(value)
    }

    @IBAction func doneButtonClicked() {
        WatchHelper.instance.transferData(amount)
        dismissController()
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
