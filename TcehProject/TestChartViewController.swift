//
//  TestChartViewController.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 29/09/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit
import Charts


class TestChartViewController: UIViewController {


    @IBOutlet weak var lineChart: GraphView!
    @IBOutlet weak var pieChart: PieChartViewMine!


    override func viewDidLoad() {
        super.viewDidLoad()

        lineChart.startAnimation(0.75)
    }


}


