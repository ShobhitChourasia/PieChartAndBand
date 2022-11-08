//
//  ColorMapper.swift
//  PieChartAndBand_Example
//
//  Created by Shobhit on 08/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

struct ColorMapper {
    
    static func getColorFromMeta(standardMeta: [StandardMeta]?) -> [UIColor] {
        guard let meta = standardMeta else { return [] }
        return meta.compactMap({ UIColor(red: (($0.color?.red ?? 0)/255),
                                         green: (($0.color?.green ?? 0)/255),
                                         blue: (($0.color?.blue ?? 0)/255), alpha: 1.0) })
    }
    
}
