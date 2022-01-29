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
    private var dragArea: DynamicOverlayDragArea = .empty

    @State
    private var scrollViewProxy: DynamicOverlayScrollViewProxy = .none

    let background: Background
    let content: Content

    @Environment(\.behaviorValue)
    var behavior: DynamicOverlayBehaviorValue

    var body: some View {
        SwiftUIOverlayContainerRepresentableAdaptor(
            adaptor: OverlayContainerRepresentableAdaptor(
                drivingScrollViewProxy: scrollViewProxy,
                dragArea: dragArea,
                behavior: behavior,
                content: OverlayContentHostingView(),
                background: background
            )
        )
        .overlayContent(content.overlayCoordinateSpace())
        .onDragAreaChange { dragArea = $0 }
        .onDrivingScrollViewChange { scrollViewProxy = $0 }
    }
}
