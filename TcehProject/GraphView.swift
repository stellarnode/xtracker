
import UIKit
import QuartzCore


class GraphLayer: CALayer {
    dynamic var progress: Double = 0

    override init(layer: AnyObject) {       //переиспользовать другой CALayer
        super.init(layer: layer)
        if let layer = layer as? GraphLayer {
            self.progress = layer.progress
        }
    }

    required init?(coder aDecoder: NSCoder) { //если мы из сториборда и тд
        super.init(coder: aDecoder)
    }

    override init() {       //чтобы работало из objective-c
        super.init()
    }

    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "progress" {  //если меняется progress — запросить перерисовку
            return true
        }
        return super.needsDisplayForKey(key)
    }
}




enum GraphViewType: Int {
    case Line, Pie
}


@IBDesignable
class GraphView: UIView {

    var values = [100.0, 200, 400, 200, 500, 600, 100, 700] {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override class func layerClass() -> AnyClass {
        return GraphLayer.self
    }

    @IBInspectable var lineColor: UIColor = UIColor.redColor()

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        print(values)

        let rect = CGContextGetClipBoundingBox(ctx)

        UIGraphicsPushContext(ctx)
        defer { UIGraphicsPopContext() }

        let p = (layer.presentationLayer() as? GraphLayer)?.progress ?? 0



        UIColor.lightGrayColor().setStroke()

        let xAxis = UIBezierPath()
        xAxis.lineWidth = 2
        xAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        xAxis.addLineToPoint(CGPoint(x: rect.width - 8, y: rect.height - 8))
        xAxis.stroke()

        let yAxis = UIBezierPath()
        yAxis.lineWidth = 2
        yAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        yAxis.addLineToPoint(CGPoint(x: 8, y: 8))
        yAxis.stroke()

        guard values.count > 1 else { return }

        let firstValue = values[0]
        let maxValue = values.maxElement()

        lineColor.setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.lineWidth = 2
        let height = rect.height - 16
        let pointHeight = CGFloat(firstValue) / CGFloat(maxValue!) * height
        let point = CGPoint(x: 8, y: rect.height - 8 - pointHeight * CGFloat(p))
        graphPath.moveToPoint(point)

        let stepX = (rect.width - 16) / CGFloat(values.count - 1)

        for i in 1..<values.count {
            let value = values[i]
            let pointHeight = CGFloat(value) / CGFloat(maxValue!) * height
            let point = CGPoint(x: 8 + stepX * CGFloat(i), y: rect.height - 8 - pointHeight * CGFloat(p))
            graphPath.addLineToPoint(point)
        }

        graphPath.stroke()

    }


    func startAnimation(duration: Double) {
        let animation = CABasicAnimation(keyPath: "progress")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        layer.addAnimation(animation, forKey: "anykey")
    }


}
