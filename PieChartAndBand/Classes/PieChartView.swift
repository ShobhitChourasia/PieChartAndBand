//
//  PieChartView.swift
//  PieChartAndBand
//
//  Created by Shobhit on 06/11/22.
//

import UIKit

public class PieChartView: UIView {
    public var startValue: CGFloat = 0 
    public var endValue: CGFloat = 1 // Should be greater than end value
    public var highlightValue: CGFloat = 0 // Default to start value
    
    public var startAngleForPieLayer: CGFloat = .pi * 0.5
    public var endAngleForPieLayer: CGFloat = .pi * 2
    public var endAngleForTrackLayer: CGFloat = .pi * 2
    
    public var pieRadius: CGFloat = 150
    
    private var markerLabelHeight: CGFloat = 25
    private var markerLabelWidth: CGFloat = 100
    private var timer = Timer()
    private let shapeLayer = CAShapeLayer()
    private var circularPath = UIBezierPath()
    private var minValue = 0
    
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
                                    startAngle: startAngleForPieLayer, //pi = 180 degree
                                    endAngle: endAngleForPieLayer,
                                    clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.lineWidth = 25
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        drawPieTrackLayer()
        layer.addSublayer(shapeLayer)
    }
    
    func animatePie() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        let toValue = (highlightValue - startValue)/(endValue - startValue)
        
        animation.toValue = toValue
        animation.duration = 1.3
        animation.isRemovedOnCompletion = false
//        animation.fillMode = .forwards
        
        shapeLayer.add(animation, forKey: "animation")
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
    
    func drawPieTrackLayer() {
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        layer.addSublayer(trackLayer)
    }
}

private typealias AnimationHelper = PieChartView
private extension AnimationHelper {
    
    func animateNumber() {
        centerLabel.text = "\(Int(startValue))"
        timer = Timer.scheduledTimer(withTimeInterval: 0.09, repeats: true, block: { _ in
            self.countUp()
        })
    }
    
    @objc func countUp() {
        if self.minValue < Int(highlightValue) {
            self.minValue += 51 // Steps by 51 to finish with animation
            let score = (self.minValue > Int(self.highlightValue)) ? Int(self.highlightValue) : self.minValue
            
            DispatchQueue.main.async {
                self.centerLabel.text = "\(score)"
                self.centerLabel.textColor = .red//self.colorForRange(creditRange: self.getRangeForScore(score: score))
                self.shapeLayer.strokeColor = UIColor.green.cgColor//self.colorForRange(creditRange: self.getRangeForScore(score: score)).cgColor
            }
        } else {
            timer.invalidate()
        }
    }
}
