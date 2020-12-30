//
//  MagneticNotchOverlayBehavior.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

/// A `DynamicOverlayBehavior` instance describing an overlay that can be dragged up and down alongside predefined notches.
/// Whenever a drag gesture ends, the overlay motion will continue until it reaches one of its notches.
public struct MagneticNotchOverlayBehavior<Notch> where Notch: CaseIterable, Notch: Equatable {

    let value: Value

    /// Creates a behavior with the given notches.
    ///
    /// - parameter notches: The notches.
    ///
    /// - returns: A behavior with the specified notches.
    public init(notches: @escaping (Notch) -> NotchDimension) {
        self.value = Value(dimensions: notches)
    }

    init(value: Value) {
        self.value = value
    }
}

public extension MagneticNotchOverlayBehavior {

    /// The attributes of a translation
    struct Translation {
        /// The current overlay height.
        public let height: CGFloat
        /// The transaction associated to the translation.
        public let transaction: Transaction
    }

    /// Adds an action to perform when the overlay moves.
    ///
    /// - parameter action: The action to perform when the translation changes. The action closure’s parameter contains the current translation.
    ///
    /// - returns: A version of the behavior that triggers the action when the translation changes.
    func onTranslation(_ action: @escaping (Translation) -> Void) -> Self {
        MagneticNotchOverlayBehavior(value: value.appending(action))
    }
}

public extension MagneticNotchOverlayBehavior {

    /// Updates the current overlay notch as it changes.
    ///
    /// - parameter binding: A binding to a notch property.
    ///
    /// - returns: A version of the behavior that updates the current overlay notch as it changes.
    func notchChange(_ binding: Binding<Notch>) -> Self {
        MagneticNotchOverlayBehavior(value: value.setting(binding))
    }
}

public extension MagneticNotchOverlayBehavior {

    /// Disables a notch.
    ///
    /// - parameter notch: The notch to disable.
    /// - parameter isDisabled: A boolean indicating whether the notch should be disabled.
    ///
    /// - returns: A version of the behavior that disables the specified notch.
    ///
    /// When a notch is disabled the overlay can not be dragged to it.
    /// The `notchChange` binding is still effective though.
    func disable(_ notch: Notch, _ isDisabled: Bool = true) -> Self {
        MagneticNotchOverlayBehavior(value: value.disabling(isDisabled, notch))
    }
}

extension MagneticNotchOverlayBehavior: DynamicOverlayBehavior {

    public func makeModifier() -> AddDynamicOverlayBehaviorModifier {
        AddDynamicOverlayBehaviorModifier(value: buildValue())
    }
}

/// A dimension of a notch.
public struct NotchDimension: Hashable {

    let type: ValueType
    let value: Double
}

public extension NotchDimension {

    /// Creates a dimension with an absolute point value.
    static func absolute(_ value: Double) -> NotchDimension {
        NotchDimension(type: .absolute, value: value)
    }

    /// Creates a dimension that is computed as a fraction of the height of the overlay parent view.
    static func fractional(_ value: Double) -> NotchDimension {
        NotchDimension(type: .fractional, value: value)
    }
}
