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
    private var handleValue: DynamicOverlayDragHandle = .default

    @State
    private var searchsScrollView = false

    let background: Background
    let content: Content

    @Environment(\.behaviorValue)
    var behavior: DynamicOverlayBehaviorValue

    var body: some View {
        SwiftUIOverlayContainerRepresentableAdaptator(
            adaptator: OverlayContainerRepresentableAdaptator(
                searchsScrollView: searchsScrollView,
                handleValue: handleValue,
                behavior: behavior,
                content: OverlayContentHostingView(),
                background: background
            )
        )
        .overlayContent(content.overlayCoordinateSpace())
        .onDragHandleChange { handleValue = $0 }
        .onDrivingScrollViewChange { value in searchsScrollView = value }
    }
}
