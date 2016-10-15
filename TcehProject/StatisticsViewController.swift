
import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit
import Charts
import CoreData


class StatisticsViewController: UIViewController {

    // MARK: Leftovers from manually drawn graphs experiments

    // @IBOutlet weak var lineGraphView: GraphView!
    // @IBOutlet weak var pieChartViewMine: PieChartViewMine!


    // MARK: Properties definitions

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!

    let segmentedItems = ["Line Chart", "Pie Chart"]


    // MARK: Load views

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let entries = (Entry.loadEntries() as [Entry])

        guard entries.count > 0 else { return }

        let promises = entries.map { (entry: Entry) -> Promise<Entry> in
            return convertAmount(entry)
        }

        var convertedEntries = [Entry]()

        for promise in promises {
            promise.then { [weak self] convertedEntry -> Void in

                guard let strongSelf = self else { return }

                convertedEntries.append(convertedEntry)

                if convertedEntries.count == entries.count {
                    strongSelf.assignValues(convertedEntries)
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlTapped(_:)),
            forControlEvents: .ValueChanged)
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl

        lineChartView.delegate = self
        configureLineChart()
        pieChartView.delegate = self
        configurePieChart()
    }
}


// MARK: Segmented Control Switcher Handler

extension StatisticsViewController {
    func segmentedControlTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            lineChartView.hidden = false
            pieChartView.hidden = true
        case 1:
            lineChartView.hidden = true
            pieChartView.hidden = false
        default:
            lineChartView.hidden = false
            pieChartView.hidden = true
        }
    }
}


// MARK: Load and assign data for graphs

extension StatisticsViewController {

    private func loadData() {
        let count = NSExpression(forFunction: "sum:",
                                 arguments: [NSExpression(forKeyPath: "amount")])
        let description = NSExpressionDescription()
        description.name = "categoryCount"
        description.expression = count
        description.expressionResultType = .DoubleAttributeType
        let request = NSFetchRequest(entityName: "Entry")
        request.propertiesToGroupBy = ["category"]
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = ["category", description]
        do {
            var results = try CoreDataHelper.instance.context
                .executeFetchRequest(request) as! [[String: AnyObject]]
            print(results)

            var categories: [String] = []
            var values: [Double] = []
            results.sortInPlace { $0["categoryCount"] as! Double > $1["categoryCount"] as! Double }
            for result in results {
                categories.append(result["category"] as! String)
                values.append(result["categoryCount"] as! Double)
            }
            setPieChartData(values, dataPoints: categories)
        } catch let error {
            print("could not load category data for pie chart due to error: \(error)")
        }
    }


    private func convertAmount(entry: Entry) -> Promise<Entry> {
        return Promise { fulfill, _ in
            entry.amountConvertedToBaseCurrency = nil

            if entry.currency != Currency.baseCurrency {
                let (url, params) = Currency.getFXRateURLandParams(entry.currency!,
                    to: Currency.baseCurrency, date: entry.date!)

                print("\(url) \n \(params)")

                Alamofire.request(.GET, url, parameters: params).responseJSON { response in
                    if let value = response.result.value {
                        let json = JSON(value)
                        let source = json["source"].string!
                        //              let fxRate = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!
                        let fromCurrency = json["quotes"]["\(source)\(entry.currency!)"].double!
                        let toCurrency = json["quotes"]["\(source)\(Currency.baseCurrency)"].double!

                        print(entry.amount)

                        entry.amountConvertedToBaseCurrency = entry.amount / fromCurrency * toCurrency
                        fulfill(entry)
                    }
                }
            } else {
                fulfill(entry)
            }
        }
    }


    private func assignValues(entries: [Entry]) {
        let entries = Array(entries).sort { $0.date?.timeIntervalSince1970 < $1.date?.timeIntervalSince1970 }
        let values = entries.map { (entry: Entry) -> Double in
            if let value = entry.amountConvertedToBaseCurrency {
                return value
            } else {
                return entry.amount
            }
        }

        let labels = entries.map { (entry: Entry) -> String in
            return ""
        }

        print(values)
        print(labels)

        // lineGraphView.values = values
        // pieChartViewMine.values = values
        
        setLineChartData(values, labels: labels)
    }
}


// MARK: Set up Line Chart View

extension StatisticsViewController {

    private func configureLineChart() {
//        lineChartView.descriptionText = "Tap node for details"
        lineChartView.descriptionTextColor = UIColor.darkGrayColor()
        lineChartView.gridBackgroundColor = UIColor.blueColor()
        lineChartView.noDataText = "No data provided"
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.animate(yAxisDuration: 0.4, easingOption: .EaseInOutCubic)
        lineChartView.descriptionText = ""
    }

    private func setLineChartData(values: [Double], labels: [String]) {

        // let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August", "Sept", "Oct", "Nov", "Dec"]
        // let dollars1 = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]

        var yVals1: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(value: values[i], xIndex: i))
        }

        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Expenses in time")
        set1.axisDependency = .Left
        let color = UIColor.redColor()
        set1.setColor(color.colorWithAlphaComponent(0.5))
        set1.setCircleColor(color)
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = color
        set1.highlightColor = UIColor.darkGrayColor()
        set1.drawCircleHoleEnabled = true

        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)

        let data: LineChartData = LineChartData(xVals: labels, dataSets: dataSets)
        data.setValueTextColor(UIColor.grayColor())

        self.lineChartView.data = data
    }
}


// MARK: Set up Pie Chart View

extension StatisticsViewController {

    private func configurePieChart() {
        pieChartView.usePercentValuesEnabled = true
        pieChartView.rotationEnabled = true
        pieChartView.animate(yAxisDuration: 0.4)
        pieChartView.descriptionText = "Expenses by category"
        pieChartView.drawSliceTextEnabled = false

    }

    private func setPieChartData(values: [Double], dataPoints: [String]) {
//        let dataPoints = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Categories")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        let percentFormatter = NSNumberFormatter()
        percentFormatter.numberStyle = .PercentStyle
        percentFormatter.multiplier = 1.0
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 1
        pieChartData.setValueFormatter(percentFormatter)
        pieChartView.data = pieChartData

        var colors: [UIColor] = []

        for _ in 0..<dataPoints.count {
            let color = getRandomColor()
            colors.append(color)
        }

        pieChartDataSet.colors = colors
    }


    func getRandomColor() -> UIColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        return color
    }

}


// MARK: ChartViewDelegate Methods

extension StatisticsViewController: ChartViewDelegate {

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry,
                            dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
    }

    @IBAction func saveChartButton(sender: UIBarButtonItem) {
        if lineChartView.hidden == false {
            lineChartView.saveToCameraRoll()
        } else if pieChartView.hidden == false {
            pieChartView.saveToCameraRoll()
        }
    }

}




