//
//  Observable.swift
//  PieChartAndBand_Example
//
//  Created by Shobhit on 08/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

public class Observable<T> {
    public var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    public init(value: T) {
        self.value = value
    }
    
    public func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
