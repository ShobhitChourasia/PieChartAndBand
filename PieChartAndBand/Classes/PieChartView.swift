//
//  PieChartView.swift
//  PieChartAndBand
//
//  Created by Shobhit on 06/11/22.
//

import UIKit

final public class PieChartView: UIView {
    
    /**
     * Specifies the start value of the meter.
     */
    public var startValue = 0
    
    /**
     * Specifies the end or last value of the meter.
     * Should be greater than end value.
     */
    public var endValue = 1
    
    /**
     * Specifies the value to be highlighted on the meter.
     */
    public var highlightValue = 0
    
    /**
     * Specifies angle or position where the pie meter should start.
     * Defaults to 0. Use .pi to go clockwise. .pi = 180 degree.
     */
    public var startAngleForPieLayer: CGFloat = .pi * 0.5
    
    /**
     * Specifies angle or position where the pie meter should end.
     * Defaults to 0. Use .pi to go clockwise. .pi = 180 degree.
     */
    public var endAngleForPieLayer: CGFloat = .pi * 2
    
    /**
     * Specifies angle or position where the pie meter tracker should start.
     * Defaults to 0. Use .pi to go clockwise. .pi = 180 degree.
     */
    public var endAngleForTrackLayer: CGFloat = .pi * 2
    
    /**
     * Specifies the line width of pie meter.
     * Defaults to 25.
     */
    public var pieMeterLineWidth: CGFloat = 25
    
    /**
     * Specifies the line width of pie meter tracker.
     * Defaults to 20.
     */
    public var pieMeterTrackerLineWidth: CGFloat = 20
    
    /**
     * Specifies angle or position where the pie meter should start.
     * Defaults to 0. Use .pi to go clockwise. .pi = 180 degree.
     */
    public var pieRadius: CGFloat = 50
    
    /**
     * Defines the default stroke colour.
     * Defaults to gray.
     */
    public var defaultStrokeColor: UIColor = .gray
    
    /**
     * Defines the default default center label colour.
     * Defaults to gray.
     */
    public var defaultCenterLabelColor: UIColor = .gray
    
    /**
     * Array to take the various data ranges of band for meter
     * Defaults is empty. Add values if you have to add custom colours.
     */
    public var bandDataArray: [(Int, Int)] = []
    
    /**
     * Array to take the various colour ranges of band for meter
     * Defaults is empty. Add values if you have to add custom colours.
     */
    public var bandColorArray: [UIColor] = []
    
    ///Private properties for configuration
    private var markerLabelHeight: CGFloat = 25
    private var markerLabelWidth: CGFloat = 100
    private var timer = Timer()
    private let shapeLayer = CAShapeLayer()
    private var circularPath = UIBezierPath()
    private var minValue = 0
    private let numberAnimationTimerDuration: TimeInterval = 0.09
    private let pieMeterAnimationDuration: CFTimeInterval = 1.3
    
    private let startMarkerLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    private let finishMarkerLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    private let centerLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 100, weight: .semibold)
        label.clipsToBounds = false
        label.sizeToFit()
        return label
    }()
 
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        minValue = Int(startValue) - 1
    }
    
    /**
     * Use this method to create the pie meter.
     * This internally draws, animates and add start and end labels to the pie by default.
     */
    public func createPie() {
        drawPie()
        animatePie()
        createMarkerLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias ViewDecorator = PieChartView
private extension ViewDecorator {
    
    func drawPie() {
        circularPath = UIBezierPath(arcCenter: center,
                                    radius: pieRadius,
                                    startAngle: startAngleForPieLayer,
                                    endAngle: endAngleForPieLayer,
                                    clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.lineWidth = pieMeterLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        drawPieTrackLayer()
        layer.addSublayer(shapeLayer)
    }
    
    func animatePie() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        let toValue = CGFloat(highlightValue - startValue)/CGFloat(endValue - startValue)
        
        animation.toValue = toValue
        animation.duration = pieMeterAnimationDuration
        animation.isRemovedOnCompletion = false
//        animation.fillMode = CAMediaTimingFillMode.forwards
        
        shapeLayer.add(animation, forKey: "animation")
    }
    
    func drawPieTrackLayer() {
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = pieMeterTrackerLineWidth
        layer.addSublayer(trackLayer)
    }
    
    func createMarkerLabels() {
        startMarkerLabel.text = "\(Int(startValue))"
        finishMarkerLabel.text = "\(Int(endValue))"
        animateNumber()
        
        centerLabel.sizeToFit()
        centerLabel.adjustsFontSizeToFitWidth = true
        
        startMarkerLabel.frame = CGRect(x: circularPath.cgPath.currentPoint.x - pieRadius - markerLabelHeight,
                                        y: circularPath.cgPath.currentPoint.y + pieRadius - markerLabelHeight/2,
                                        width: markerLabelWidth,
                                        height: markerLabelHeight)
        
        finishMarkerLabel.frame = CGRect(x: circularPath.cgPath.currentPoint.x - pieRadius/2 + markerLabelHeight,
                                         y: circularPath.cgPath.currentPoint.y,
                                         width: markerLabelWidth,
                                         height: markerLabelHeight)
        
        addSubview(centerLabel)
        addSubview(startMarkerLabel)
        addSubview(finishMarkerLabel)
        centerLabel.center = center
    }
    
}

private typealias AnimationHelper = PieChartView
private extension AnimationHelper {
    
    func animateNumber() {
        centerLabel.text = "\(Int(startValue))"
        timer = Timer.scheduledTimer(withTimeInterval: numberAnimationTimerDuration, repeats: true, block: { _ in
            self.countUp()
        })
    }
    
    @objc func countUp() {
        if self.minValue < Int(highlightValue) {
            self.minValue += 51 // Steps by 51 to finish with animation
            let score = (self.minValue > Int(self.highlightValue)) ? Int(self.highlightValue) : self.minValue
            
            DispatchQueue.main.async {
                self.centerLabel.text = "\(score)"
                self.centerLabel.textColor = self.animateColors(forScore: score) ?? self.defaultCenterLabelColor
                self.shapeLayer.strokeColor = self.animateColors(forScore: score)?.cgColor ?? self.defaultStrokeColor.cgColor
            }
        } else {
            timer.invalidate()
        }
    }
}

private typealias ColorHelper = PieChartView
private extension ColorHelper {
    
    func animateColors(forScore score: Int) -> UIColor? {
        guard !bandColorArray.isEmpty &&
                !bandDataArray.isEmpty &&
                bandColorArray.count == bandDataArray.count else { return nil }
        //score >= 825 && score <= 900
        let index = bandDataArray.firstIndex(where: {
            score >= $0.0 && score <= $0.1
        })
        
        guard let index = index else { return bandColorArray[bandDataArray.count - 1] }
        return bandColorArray[index]
    }
    
}
