//
//  DynamicOverlayStyle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

/// A protocol that describes the behavior and appearance of a dynamic overlay.
public protocol DynamicOverlayStyle {

    func makeModifier() -> DynamicOverlayStyleModifier
}

public extension View {

    /// Sets the style for dynamic overlays within this view.
    func dynamicOverlayStyle<Style: DynamicOverlayStyle>(_ style: Style) -> some View {
        modifier(style.makeModifier())
    }
}

public struct ShrinkableDynamicOverlayStyle: DynamicOverlayStyle {

    public init() {}

    public func makeModifier() -> DynamicOverlayStyleModifier {
        DynamicOverlayStyleModifier(style: .shrinkable)
    }
}
