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

public struct MagneticNotchOverlayBehavior<Notch> where Notch: CaseIterable, Notch: Equatable {

    let value: Value

    public init(dimensions: @escaping (Notch) -> NotchDimension) {
        self.value = Value(dimensions: dimensions)
    }

    init(value: Value) {
        self.value = value
    }
}

public extension MagneticNotchOverlayBehavior {

    struct Translation {
        public let height: CGFloat
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

    public func makeModifier<Overlay>(overlay: Overlay) -> DynamicOverlayModifier<Overlay> where Overlay : View {
        DynamicOverlayModifier(
            overlay: overlay,
            behaviorValue: buildValue()
        )
    }
}
