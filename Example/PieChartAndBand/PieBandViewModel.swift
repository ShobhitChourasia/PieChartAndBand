//
//  PieBandViewModel.swift
//  PieChartAndBand_Example
//
//  Created by Shobhit on 08/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class PieBandViewModel {
        
    var dataModel = Observable<PieBandDataModel?>(value: nil)
    var bandDataArray = Observable<[(Int, Int)]>(value: [])
    var bandColorArray = Observable<[UIColor]>(value: [])
    
    private let dataManager: DataManager
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getData() {
        dataManager.getData { [weak self] dataModel, _ in
            guard let self = self else { return }
            self.dataModel.value = dataModel
            
            if let meta = dataModel?.standardMeta {
                self.bandDataArray.value = meta.compactMap({ ($0.rangeStart ?? 0, $0.rangeEnd ?? 0) })
                self.bandColorArray.value = meta.compactMap({ UIColor(red: (($0.color?.red ?? 0)/255),
                                                                      green: (($0.color?.green ?? 0)/255),
                                                                      blue: (($0.color?.blue ?? 0)/255), alpha: 1.0)})
            }

        }
    }
}
