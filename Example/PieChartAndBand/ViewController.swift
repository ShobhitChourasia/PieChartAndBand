//
//  ViewController.swift
//  PieChartAndBand
//
//  Created by Shobhit Chourasia on 11/06/2022.
//  Copyright (c) 2022 Shobhit Chourasia. All rights reserved.
//

import PieChartAndBand

class ViewController: UIViewController {
    
    private let viewModel = PieBandViewModel(dataManager: DataManager())
    private var highlightValue = 0
    private var startValue = 0
    private var endValue = 0
    private var bandDataArray: [(Int, Int)] = []
    private var bandColorArray: [UIColor] = []
    private var bandPercentCoverage: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.getData()
        bindViewModelProps()
    }
    
}

private typealias ViewModelHelper = ViewController
private extension ViewModelHelper {
    
    func bindViewModelProps() {
        viewModel.dataModel.bind { [weak self] pieBandDataModel in
            guard let self = self else { return }
            self.highlightValue = pieBandDataModel?.creditScore ?? 0
            self.startValue = pieBandDataModel?.startValue ?? 0
            self.endValue = pieBandDataModel?.endValue ?? 0
            self.bandColorArray = ColorMapper.getColorFromMeta(standardMeta: pieBandDataModel?.standardMeta)
            self.bandDataArray = self.viewModel.bandDataArray.value
            self.bandPercentCoverage = self.viewModel.bandPercentCoverage.value
            DispatchQueue.main.async {
                self.setupViews()
            }
        }
    }
}

private extension ViewController {
    
    func setupViews() {
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
        
        pieView.startValue = startValue
        pieView.endValue = endValue
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
        bandView.bandHighlightedValueImage = .init(named: "arrow_left_thick_medium")
        bandView.createBands(bandDataArray: bandDataArray,
                             bandColorArray: bandColorArray,
                             bandPercentCoverage: bandPercentCoverage)
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
