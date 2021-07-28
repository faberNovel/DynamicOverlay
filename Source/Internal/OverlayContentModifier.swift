//
//  OverlayContentModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 03/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct OverlayContentModifier<Overlay: View>: ViewModifier {

    let overlay: Overlay

    func body(content: Content) -> some View {
        content.environment(\.overlayContentKey, AnyView(overlay))
    }
}

extension View {

    func overlayContent<Content: View>(_ content: Content) -> ModifiedContent<Self, OverlayContentModifier<Content>> {
        modifier(OverlayContentModifier(overlay: content))
    }
}

/// The root view of the overlay content
struct OverlayContentHostingView: View {

    /// We use an environment variable to avoid UIViewController allocations each time the content changes.
    @Environment(\.overlayContentKey)
    var content: AnyView

    var body: some View {
        content
    }
}

private struct OverlayContentKey: EnvironmentKey {

    static var defaultValue = AnyView(EmptyView())
}

private extension EnvironmentValues {

    var overlayContentKey: AnyView {
        set {
            self[OverlayContentKey.self] = newValue
        }
        get {
            self[OverlayContentKey.self]
        }
    }
}
