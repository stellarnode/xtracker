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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(tapAction))

    }

    func tapAction() {
        UIGraphicsBeginImageContextWithOptions(lineChart.bounds.size, true, 0)
        defer { UIGraphicsEndImageContext() }

        lineChart.drawViewHierarchyInRect(lineChart.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()!

        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        presentViewController(controller, animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }


}


