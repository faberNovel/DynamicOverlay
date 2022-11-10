//
//  OverlayContainerView.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct OverlayContainerDynamicOverlayView<Background: View, Content: View>: View {

    @State
    private var dragArea: DynamicOverlayDragArea = .default

    @State
    private var scrollViewProxy: DynamicOverlayScrollViewProxy = .default

    @State
    private var passiveContainer = OverlayContainerPassiveContainer()

    @Environment(\.behaviorValue)
    private var behavior: DynamicOverlayBehaviorValue

    let background: Background
    let content: Content

    // MARK: - View

    var body: some View {
        SwiftUIOverlayContainerRepresentableAdaptor(
            adaptor: OverlayContainerRepresentableAdaptor(
                containerState: makeContainerState(),
                passiveContainer: passiveContainer,
                content: OverlayContentHostingView(),
                background: background
            )
        )
        .overlayContent(content.overlayCoordinateSpace())
        .onUpdate {
            passiveContainer.onTranslation = behavior.block
            // This is tricky. `OverlayContainerPassiveContainer` is a class inside a struct,
            // `passiveContainer.onNotchChange = { self.behavior.binding?.wrappedValue = $0 }`
            // would create a retain cycle as `self` includes a ref to `passiveContainer`.
            let behavior = behavior
            passiveContainer.onNotchChange = { behavior.binding?.wrappedValue = $0 }
        }
        .onDragAreaChange {
            dragArea = $0
        }
        .onDrivingScrollViewChange {
            scrollViewProxy = $0
        }
    }

    // MARK: - Private

    private func makeContainerState() -> OverlayContainerState {
        OverlayContainerState(
            dragArea: dragArea,
            drivingScrollViewProxy: scrollViewProxy,
            notchIndex: behavior.binding?.wrappedValue,
            disabledNotches: behavior.disabledNotchIndexes,
            layout: OverlayContainerLayout(indexToDimension: behavior.notchDimensions ?? [:])
        )
    }
}

private extension View {

    func onUpdate(_ block: () -> Void) -> some View {
        block()
        return self
    }
}
