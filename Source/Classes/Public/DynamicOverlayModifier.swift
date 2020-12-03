//
//  DynamicOverlayModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dynamicOverlay<Content: View, Transition: DynamicOverlayTransition>(_ content: Content, transition: Transition) -> some View {
        ModifiedContent(
            content: self,
            modifier: transition.makeModifier(overlay: content)
        )
    }
}

public struct DynamicOverlayModifier<Overlay: View>: ViewModifier {

    let overlay: Overlay
    let transitionValue: DynamicOverlayTransitionValue?

    init(overlay: Overlay,
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
