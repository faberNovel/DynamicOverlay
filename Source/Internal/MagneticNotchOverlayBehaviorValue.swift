//
//  MagneticNotchOverlayBehaviorValue.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension MagneticNotchOverlayBehavior {

    struct Value {

        let dimensions: (Notch) -> NotchDimension
        let translationBlocks: [(Translation) -> Void]
        let binding: Binding<Notch>?
        let disabledNotches: [Notch]

        init(dimensions: @escaping (Notch) -> NotchDimension,
             translationBlocks: [(Translation) -> Void],
             binding: Binding<Notch>?,
             disabledNotches: [Notch]) {
            self.dimensions = dimensions
            self.translationBlocks = translationBlocks
            self.binding = binding
            self.disabledNotches = disabledNotches
        }

        init(dimensions: @escaping (Notch) -> NotchDimension) {
            self.dimensions = dimensions
            self.translationBlocks = []
            self.binding = nil
            self.disabledNotches = []
        }

        // MARK: - Public

        func appending(_ block: @escaping (Translation) -> Void) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks + [block],
                binding: binding,
                disabledNotches: disabledNotches
            )
        }

        func setting(_ binding: Binding<Notch>) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding,
                disabledNotches: disabledNotches
            )
        }

        func disabling(_ isDisabled: Bool, _ notch: Notch) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding,
                disabledNotches: isDisabled ? disabledNotches + [notch] : disabledNotches
            )
        }
    }
}
