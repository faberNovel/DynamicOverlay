//
//  DynamicOverlayNotchTransition+Transition.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension NotchDimension {

    enum ValueType: Hashable {
        case absolute
        case fractional
    }
}

extension DynamicOverlayNotchTransition: DynamicOverlayTransition {

    // MARK: - DynamicOverlayTransition

    func buildValue() -> DynamicOverlayTransitionValue {
        DynamicOverlayTransitionValue(
            notchDimensions: Dictionary(
                uniqueKeysWithValues: Notch.allCases.enumerated().map { i, notch in (i, dimensions(notch)) }
            ),
            block: blocks.isEmpty ? nil : { height in
                blocks.forEach { $0(Value(translation: height)) }
            },
            binding: binding?.indexBinding()
        )
    }
}
