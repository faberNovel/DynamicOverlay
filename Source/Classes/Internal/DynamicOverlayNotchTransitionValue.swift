//
//  DynamicOverlayNotchTransitionValue.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension DynamicOverlayNotchTransition {

    struct Value {

        let dimensions: (Notch) -> NotchDimension
        let translationBlocks: [(Translation) -> Void]
        let binding: Binding<Notch>?

        init(dimensions: @escaping (Notch) -> NotchDimension,
             translationBlocks: [(DynamicOverlayNotchTransition<Notch>.Translation) -> Void] = [],
             binding: Binding<Notch>? = nil) {
            self.dimensions = dimensions
            self.translationBlocks = translationBlocks
            self.binding = binding
        }

        // MARK: - Public

        func appending(_ block: @escaping (Translation) -> Void) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks + [block],
                binding: binding
            )
        }

        func setting(_ binding: Binding<Notch>) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                binding: binding
            )
        }
    }
}
