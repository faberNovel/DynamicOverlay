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
        let contentAdjustmentMode: ContentAdjustmentMode

        init(dimensions: @escaping (Notch) -> NotchDimension,
             translationBlocks: [(Translation) -> Void],
             binding: Binding<Notch>?,
             disabledNotches: [Notch],
             contentAdjustmentMode: ContentAdjustmentMode) {
            self.dimensions = dimensions
            self.translationBlocks = translationBlocks
            self.binding = binding
            self.disabledNotches = disabledNotches
            self.contentAdjustmentMode = contentAdjustmentMode
        }

        init(dimensions: @escaping (Notch) -> NotchDimension) {
            self.dimensions = dimensions
            self.translationBlocks = []
            self.binding = nil
            self.disabledNotches = []
            self.contentAdjustmentMode = .none
        }

        // MARK: - Public

        func appending(_ block: @escaping (Translation) -> Void) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks + [block],
                binding: binding,
                disabledNotches: disabledNotches,
                contentAdjustmentMode: contentAdjustmentMode
            )
        }

        func setting(_ binding: Binding<Notch>) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding,
                disabledNotches: disabledNotches,
                contentAdjustmentMode: contentAdjustmentMode
            )
        }

        func disabling(_ isDisabled: Bool, _ notch: Notch) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding,
                disabledNotches: isDisabled ? disabledNotches + [notch] : disabledNotches,
                contentAdjustmentMode: contentAdjustmentMode
            )
        }

        func contentAdjustmentMode(_ contentAdjustmentMode: ContentAdjustmentMode) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding,
                disabledNotches: disabledNotches,
                contentAdjustmentMode: contentAdjustmentMode
            )
        }
    }
}
