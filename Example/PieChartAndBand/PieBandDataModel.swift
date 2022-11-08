//
//  PieBandDataModel.swift
//  PieChartAndBand_Example
//
//  Created by Shobhit on 08/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PieBandDataModel: Codable {
    let startValue, endValue, creditScore: Int?
    let standardMeta: [StandardMeta]?
}

// MARK: - StandardMeta
struct StandardMeta: Codable {
    let rangeStart, rangeEnd, percentCoverage: Int?
    let color: BandColor?
}

// MARK: - Color
struct BandColor: Codable {
    let red, green, blue: CGFloat?
}
