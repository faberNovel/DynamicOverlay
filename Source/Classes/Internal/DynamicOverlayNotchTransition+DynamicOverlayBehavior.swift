//
//  MagneticNotchOverlayBehavior+DynamicOverlayBehavior.swift
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

extension MagneticNotchOverlayBehavior {

    // MARK: - DynamicOverlayBehavior

    func buildValue() -> DynamicOverlayBehaviorValue {
        DynamicOverlayBehaviorValue(
            notchDimensions: Dictionary(
                uniqueKeysWithValues: Notch.allCases.enumerated().map { i, notch in (i, value.dimensions(notch)) }
            ),
            block: value.translationBlocks.isEmpty ? nil : { translation in
                value.translationBlocks.forEach {
                    $0(
                        Translation(
                            height: translation.height,
                            transaction: translation.transaction,
                            progress: Double(min(max(translation.translationProgress, 0), 1)),
                            containerSize: translation.containerFrame.size,
                            heightForNotch: { notch in
                                translation.heightForNotchIndex(Notch.index(of: notch))
                            }
                        )
                    )
                }
            },
            binding: value.binding?.indexBinding(),
            disabledNotchIndexes: Set(value.disabledNotches.map { Notch.index(of: $0) })
        )
    }
}
