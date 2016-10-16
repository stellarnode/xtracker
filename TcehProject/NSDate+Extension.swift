//
//  NSDate+Extension.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 15/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit

extension NSDate {

    func getMonthAndYearOnly() -> NSDate {

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)

        // let year =  components.year
        // let month = components.month

        let monthAndYearOnly = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(components)

        return monthAndYearOnly!
    }

}
