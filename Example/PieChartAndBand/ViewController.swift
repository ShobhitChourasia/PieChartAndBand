//
//  ViewController.swift
//  PieChartAndBand
//
//  Created by Shobhit Chourasia on 11/06/2022.
//  Copyright (c) 2022 Shobhit Chourasia. All rights reserved.
//

import PieChartAndBand

class ViewController: UIViewController {
    
    private let bandDataArray = [(825, 900),
                                 (800, 824),
                                 (775, 799),
                                 (700, 774),
                                 (300, 699)]
    private let bandColorArray = [UIColor(red: 102/255, green: 204/255, blue: 0/255, alpha: 1.0),
                                  UIColor(red: 204/255, green: 204/255, blue: 0/255, alpha: 1.0),
                                  UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.0),
                                  UIColor(red: 206/255, green: 103/255, blue: 0/255, alpha: 1.0),
                                  UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)]
    private let highlightValue = 820
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createPieChartView()
        createBandView()
    }
    
}

private typealias PieChartViewHelper = ViewController
private extension PieChartViewHelper {
    
    func createPieChartView() {
        let pieView = PieChartView()
        pieView.bandDataArray = bandDataArray
        pieView.bandColorArray = bandColorArray
        
        pieView.pieRadius = 150
        
        pieView.startValue = 300
        pieView.endValue = 900
        pieView.highlightValue = highlightValue
        
        pieView.createPie()
        
        pieView.center.x = view.center.x
        pieView.center.y = view.center.y - 200
        
        view.addSubview(pieView)
    }
    
}

private typealias BandViewHelper = ViewController
private extension BandViewHelper {
    
    func createBandView() {
        let bandView = BandView(frame: view.frame)
        bandView.highlightValue = highlightValue

        bandView.createBands(bandDataArray: bandDataArray, bandColorArray: bandColorArray)
        bandView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bandView)
        
        NSLayoutConstraint.activate([
            bandView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/2),
            bandView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            bandView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bandView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
