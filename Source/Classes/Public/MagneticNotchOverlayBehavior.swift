//
//  MagneticNotchOverlayBehavior.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public struct NotchDimension: Hashable {

    let type: ValueType
    let value: Double
}

public extension NotchDimension {

    static func absolute(_ value: Double) -> NotchDimension {
        NotchDimension(type: .absolute, value: value)
    }

    static func fractional(_ value: Double) -> NotchDimension {
        NotchDimension(type: .fractional, value: value)
    }
}

public struct MagneticNotchOverlayBehavior<Notch> where Notch: CaseIterable, Notch: Equatable {

    let value: Value

    public init(notches: @escaping (Notch) -> NotchDimension) {
        self.value = Value(dimensions: notches)
    }

    init(value: Value) {
        self.value = value
    }
}

public extension MagneticNotchOverlayBehavior {

    struct Translation {
        public let height: CGFloat
        public let transaction: Transaction
    }

    func onTranslation(_ block: @escaping (Translation) -> Void) -> Self {
        MagneticNotchOverlayBehavior(value: value.appending(block))
    }
}

public extension MagneticNotchOverlayBehavior {

    func notchChange(_ binding: Binding<Notch>) -> Self {
        MagneticNotchOverlayBehavior(value: value.setting(binding))
    }
}

public extension MagneticNotchOverlayBehavior {

    func disable(_ notch: Notch, _ isDisabled: Bool = true) -> Self {
        MagneticNotchOverlayBehavior(value: value.disabling(isDisabled, notch))
    }
}

extension MagneticNotchOverlayBehavior: DynamicOverlayBehavior {

    public func makeModifier() -> AddDynamicOverlayBehaviorModifier {
        AddDynamicOverlayBehaviorModifier(value: buildValue())
    }
}
