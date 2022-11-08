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
    
    private let dataManager: DataManager
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getData() {
        dataManager.getData { [weak self] dataModel, error in
            guard let self = self else { return }
            if let dataModel = dataModel {
                self.dataModel.value = dataModel
                
                if let meta = dataModel.standardMeta {
                    self.bandDataArray.value = meta.compactMap({ ($0.rangeStart ?? 0, $0.rangeEnd ?? 0) })
                }
            } else {
                self.dataModel.value = nil
            }
        }
    }
}
