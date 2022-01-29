//
//  OverlayContainerView.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI
import OverlayContainer

struct OverlayContainerDynamicOverlayView<Background: View, Content: View>: View {

    @State
    private var dragHandle: DynamicOverlayDragHandle = .default

    @State
    private var drivingScrollViewHandle: DynamicOverlayDragHandle = .default

    let background: Background
    let content: Content

    @Environment(\.behaviorValue)
    var behavior: DynamicOverlayBehaviorValue

    var body: some View {
        SwiftUIOverlayContainerRepresentableAdaptor(
            adaptor: OverlayContainerRepresentableAdaptor(
                drivingScrollViewHandle: drivingScrollViewHandle,
                dragHandle: dragHandle,
                behavior: behavior,
                content: OverlayContentHostingView(),
                background: background
            )
        )
        .overlayContent(content.overlayCoordinateSpace())
        .onDragHandleChange { dragHandle = $0 }
        .onDrivingScrollViewChange { drivingScrollViewHandle = $0 }
    }
}
