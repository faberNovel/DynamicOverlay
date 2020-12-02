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

public protocol DynamicOverlayTransition {}

public struct DynamicOverlayNotchTransition<Notch> where Notch: CaseIterable, Notch: Equatable {

    public struct Value {
        public let translation: CGFloat
    }

    public let dimensions: (Notch) -> NotchDimension

    var blocks: [(Value) -> Void] = []
    var binding: Binding<Notch>?

    public init(dimensions: @escaping (Notch) -> NotchDimension) {
        self.dimensions = dimensions
    }

    init(dimensions: @escaping (Notch) -> NotchDimension,
         blocks: [(Value) -> Void],
         binding: Binding<Notch>?) {
        self.dimensions = dimensions
        self.blocks = blocks
        self.binding = binding
    }
}

public extension DynamicOverlayNotchTransition {

    func onChange(_ block: @escaping (Value) -> Void) -> Self {
        DynamicOverlayNotchTransition(
            dimensions: dimensions,
            blocks: blocks + [block],
            binding: binding
        )
    }
}

public extension DynamicOverlayNotchTransition {

    func notchChange(_ binding: Binding<Notch>) -> Self {
        DynamicOverlayNotchTransition(
            dimensions: dimensions,
            blocks: blocks,
            binding: binding
        )
    }
}
