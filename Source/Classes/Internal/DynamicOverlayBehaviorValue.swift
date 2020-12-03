//
//  EmptyFile.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayBehaviorValue {

    let notchDimensions: [Int: NotchDimension]?
    let block: ((CGFloat) -> Void)?
    let binding: Binding<Int>?

    init(notchDimensions: [Int: NotchDimension]? = nil,
         block: ((CGFloat) -> Void)? = nil,
         binding: Binding<Int>? = nil) {
        self.notchDimensions = notchDimensions
        self.block = block
        self.binding = binding
    }
}

extension DynamicOverlayBehaviorValue {

    static var `default`: DynamicOverlayBehaviorValue {
        DynamicOverlayBehaviorValue(
            notchDimensions: [
                0 : .fractional(0.3),
                1 : .fractional(0.5),
                2 : .fractional(0.7)
            ]
        )
    }
}
