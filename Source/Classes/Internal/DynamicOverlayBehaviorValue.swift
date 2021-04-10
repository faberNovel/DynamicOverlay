//
//  EmptyFile.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import SwiftUI

struct OverlayTranslation {
    let height: CGFloat
    let transaction: Transaction
    let isDragging: Bool
    let translationProgress: CGFloat
    let containerFrame: CGRect
    let velocity: CGPoint
    let heightForNotchIndex: (Int) -> CGFloat
}

struct DynamicOverlayBehaviorValue {

    let notchDimensions: [Int: NotchDimension]?
    let block: ((OverlayTranslation) -> Void)?
    let binding: Binding<Int>?
    let disabledNotchIndexes: Set<Int>

    init(notchDimensions: [Int: NotchDimension]? = nil,
         block: ((OverlayTranslation) -> Void)? = nil,
         binding: Binding<Int>? = nil,
         disabledNotchIndexes: Set<Int> = []) {
        self.notchDimensions = notchDimensions
        self.block = block
        self.binding = binding
        self.disabledNotchIndexes = disabledNotchIndexes
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

struct DynamicOverlayBehaviorKey: EnvironmentKey {

    static var defaultValue: DynamicOverlayBehaviorValue = .default
}

extension EnvironmentValues {

    var behaviorValue: DynamicOverlayBehaviorValue {
        set {
            self[DynamicOverlayBehaviorKey] = newValue
        }
        get {
            self[DynamicOverlayBehaviorKey]
        }
    }
}
