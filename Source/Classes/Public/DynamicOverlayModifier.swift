//
//  DynamicOverlayModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dynamicOverlay<Content: View>(_ content: Content) -> some View {
        ModifiedContent(
            content: self,
            modifier: AddDynamicOverlayModifier(overlay: content)
        )
    }

    func dynamicOverlayBehavior<Behavior: DynamicOverlayBehavior>(_ behavior: Behavior) -> some View {
        ModifiedContent(
            content: self,
            modifier: behavior.makeModifier()
        )
    }
}

public struct AddDynamicOverlayModifier<Overlay: View>: ViewModifier {

    let overlay: Overlay

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content.overlay(
            OverlayContainerDynamicOverlayView(
                content: overlay
            )
        )
    }
}

public struct AddDynamicOverlayBehaviorModifier: ViewModifier {

    let value: DynamicOverlayBehaviorValue

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content.environment(\.behaviorValue, value)
    }
}
