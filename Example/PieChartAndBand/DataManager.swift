//
//  DataManager.swift
//  PieChartAndBand_Example
//
//  Created by Shobhit on 08/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

struct DataManager {
    
    func getData(completion: (PieBandDataModel?, Error?) -> ()) { //Add escaping if the scope of func escape for some operation
        if let url = getJsonPathUrl() {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonModel = try decoder.decode(PieBandDataModel.self, from: data)
                completion(jsonModel, nil)
            } catch {
                debugPrint("error:\(error)")
                completion(nil, error)
            }
        }
    }
    
    private func getJsonPathUrl() -> URL? {
        guard let url = Bundle.main.url(forResource: "PieBandJsonData", withExtension: "json") else { return nil }
        return url
    }
}
