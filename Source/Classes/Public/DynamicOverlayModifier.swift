//
//  DynamicOverlayModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dynamicOverlay<Content: View, Behavior: DynamicOverlayBehavior>(_ content: Content, behavior: Behavior) -> some View {
        ModifiedContent(
            content: self,
            modifier: behavior.makeModifier(overlay: content)
        )
    }
}

public struct DynamicOverlayModifier<Overlay: View>: ViewModifier {

    let overlay: Overlay
    let behaviorValue: DynamicOverlayBehaviorValue?

    init(overlay: Overlay,
         behaviorValue: DynamicOverlayBehaviorValue? = nil) {
        self.overlay = overlay
        self.behaviorValue = behaviorValue
    }

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content.overlay(
            OverlayContainerDynamicOverlayView(
                content: overlay,
                behavior: behaviorValue ?? .default
            )
        )
    }
}
