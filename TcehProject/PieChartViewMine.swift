

import UIKit
import RandomColorSwift


@IBDesignable
class PieChartViewMine: UIView {

    var values = [100.0, 200, 400, 200, 500, 600, 100, 700] {
        didSet {
            print("new values are set for the pie chart")
            self.setNeedsDisplay()
        }
    }


//    func getRandomColor() -> UIColor{
//
//        let randomRed: CGFloat = CGFloat(drand48())
//        let randomGreen: CGFloat = CGFloat(drand48())
//        let randomBlue: CGFloat = CGFloat(drand48())
//        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
//        
//    }


    override func drawRect(rect: CGRect) {
        super.drawRect(rect)



        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let radius = CGFloat(100)
        let sum = values.reduce(0, combine: +)

        print("the sum of numbers is \(sum)")

        let fullCircle = CGFloat(2 * M_PI)
        var startAngle = CGFloat(0)
        var endAngle = CGFloat(0)

        var color = randomColor()

        for number in values {

            let path = UIBezierPath()
            color = randomColor()
            color.setFill()

            path.moveToPoint(center)

            endAngle = CGFloat(startAngle) + CGFloat(number / sum) * fullCircle

            path.addArcWithCenter(center,
                                  radius: radius,
                                  startAngle: startAngle,
                                  endAngle: endAngle,
                                  clockwise: true)

            path.closePath()
            path.fill()

            startAngle = endAngle

        }


    }


    

    

}
