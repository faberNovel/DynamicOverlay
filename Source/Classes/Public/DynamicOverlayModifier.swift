//
//  DynamicOverlayModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dynamicOverlay<Content: View>(_ content: Content) -> ModifiedContent<Self, DynamicOverlayModifier> {
        ModifiedContent(
            content: self,
            modifier: DynamicOverlayModifier(overlay: AnyView(content))
        )
    }
}

public extension ModifiedContent where Modifier == DynamicOverlayModifier {

    func dynamicOverlayTransition<Transition: DynamicOverlayTransition>(_ transition: Transition) -> ModifiedContent<Content, DynamicOverlayModifier> {
        ModifiedContent(
            content: content,
            modifier: transition.makeModifier(current: modifier)
        )
    }
}

public struct DynamicOverlayModifier: ViewModifier {

    let overlay: AnyView
    let transitionValue: DynamicOverlayTransitionValue?

    init(overlay: AnyView,
         transitionValue: DynamicOverlayTransitionValue? = nil) {
        self.overlay = overlay
        self.transitionValue = transitionValue
    }

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content.overlay(
            OverlayContainerDynamicOverlayView(
                content: overlay,
                transition: transitionValue ?? .default
            )
        )
    }
}
