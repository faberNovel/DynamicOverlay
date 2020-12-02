//
//  NotchDimension.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public struct NotchDimension: Hashable {

    let type: ValueType

    public let value: CGFloat
}

public extension NotchDimension {

    static func absolute(_ value: CGFloat) -> NotchDimension {
        NotchDimension(type: .absolute, value: value)
    }

    static func fractional(_ value: CGFloat) -> NotchDimension {
        NotchDimension(type: .fractional, value: value)
    }
}

public struct DynamicOverlayNotchTransition<Notch> where Notch: CaseIterable, Notch: Equatable {

    let value: Value

    public init(dimensions: @escaping (Notch) -> NotchDimension) {
        self.value = Value(dimensions: dimensions)
    }

    init(value: Value) {
        self.value = value
    }
}

public extension DynamicOverlayNotchTransition {

    struct Translation {
        public let height: CGFloat
    }

    func onTranslation(_ block: @escaping (Translation) -> Void) -> Self {
        DynamicOverlayNotchTransition(value: value.appending(block))
    }
}

public extension DynamicOverlayNotchTransition {

    func notchChange(_ binding: Binding<Notch>) -> Self {
        DynamicOverlayNotchTransition(value: value.setting(binding))
    }
}

extension DynamicOverlayNotchTransition: DynamicOverlayTransition {

    public func makeModifier(current: DynamicOverlayModifier) -> DynamicOverlayModifier {
        DynamicOverlayModifier(
            overlay: current.overlay,
            transitionValue: buildValue()
        )
    }
}
