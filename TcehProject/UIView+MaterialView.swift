//
//  UIView+MaterialView.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 16/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {

        get {

            return materialKey
        }

        set {

            materialKey = newValue

            if materialKey {

                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.3
                self.layer.shadowRadius = 1.5
                self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.7).CGColor

            } else {

                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }

        }

    }
    
}