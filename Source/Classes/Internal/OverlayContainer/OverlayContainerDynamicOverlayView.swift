//
//  OverlayContainerView.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI
import OverlayContainer

struct OverlayContainerDynamicOverlayView<Content: View>: View {

    @State
    private var handleRects: [CGRect] = []

    @State
    private var searchsScrollView = false

    let content: Content

    @Environment(\.behaviorValue)
    var behavior: DynamicOverlayBehaviorValue

    @Environment(\.overlayStyle)
    var style: OverlayStyle

    var body: some View {
        GeometryReader { proxy in
            OverlayContainerRepresentableAdaptator(
                style: style,
                searchsScrollView: searchsScrollView,
                handleRects: handleRects,
                behavior: behavior
            )
            .passThroughContent()
            .overlayContent(content)
            .onPreferenceChange(DynamicOverlayDragHandlePreferenceKey.self, perform: { value in
                handleRects = value.anchors.map { proxy[$0] }
            })
            .onPreferenceChange(DynamicOverlayScrollPreferenceKey.self, perform: { value in
                searchsScrollView = value
            })
        }
    }
}

struct OverlayContainerRepresentableAdaptator: UIViewControllerRepresentable {

    let style: OverlayStyle
    let searchsScrollView: Bool
    let handleRects: [CGRect]
    let behavior: DynamicOverlayBehaviorValue

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            searchsScrollView: searchsScrollView,
            notchIndex: behavior.binding?.wrappedValue,
            disabledNotches: behavior.disabledNotchIndexes,
            layout: OverlayContainerLayout(indexToDimension: behavior.notchDimensions ?? [:])
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        OverlayContainerCoordinator(
            layout: containerState.layout,
            content: UIHostingController(rootView: OverlayContentHostingView())
        )
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        let containerStyle: OverlayContainerViewController.OverlayStyle
        switch style {
        case .shrinkable:
            containerStyle = .flexibleHeight
        }
        let controller = OverlayContainerViewController(style: containerStyle)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        context.coordinator.notchChangeUpdateHandler = { notch in
            behavior.binding?.wrappedValue = notch
        }
        context.coordinator.translationUpdateHandler = { coordinator in
            behavior.block?(coordinator.targetTranslationHeight)
        }
        context.coordinator.shouldStartDraggingOverlay = { point in
            handleRects.contains { $0.contains(point) }
        }
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
