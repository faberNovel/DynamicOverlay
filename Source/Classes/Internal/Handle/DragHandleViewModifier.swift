//
//  DragHandleViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DragHandleViewModifier: ViewModifier {

    let isActive: Bool

    @Environment(\.containerGeometryProxy)
    var proxy: GeometryProxy?

    func body(content: Content) -> some View {
        content.preference(
            key: DynamicOverlayDragHandlePreferenceKey.self,
            value: DynamicOverlayDragHandle(
                values: [
                    DynamicOverlayDragHandle.Value(
                        frame: proxy?.frame(in: .overlayContainer) ?? .zero,
                        isActive: isActive
                    )
                ]
            )
        )
    }
}

struct OverlayContainerGeometryProxyKey: EnvironmentKey {

    static var defaultValue: GeometryProxy? = nil
}

extension EnvironmentValues {

    var containerGeometryProxy: GeometryProxy? {
        set {
            self[OverlayContainerGeometryProxyKey] = newValue
        }
        get {
            self[OverlayContainerGeometryProxyKey]
        }
    }
}
