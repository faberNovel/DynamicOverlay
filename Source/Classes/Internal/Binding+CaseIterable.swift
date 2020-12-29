//
//  Binding+CaseIterable.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension Binding where Value: Equatable, Value: CaseIterable {

    func indexBinding() -> Binding<Int> {
        Binding<Int>(
            get: {
                Value.index(of: wrappedValue)
            },
            set: { index in
                wrappedValue = Value.value(at: index)
            }
        )
    }
}

extension CaseIterable where Self: Equatable {

    static func index(of target: AllCases.Element) -> Int {
        var index = 0
        for value in allCases {
            if value == target {
                return index
            }
            index += 1
        }
        fatalError("Cannot find a valid index for \(target)")
    }

    static func value(at index: Int) -> AllCases.Element {
        allCases[allCases.index(allCases.startIndex, offsetBy: index)]
    }
}
