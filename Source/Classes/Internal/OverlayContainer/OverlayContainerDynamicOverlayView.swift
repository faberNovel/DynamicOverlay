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
        OverlayContainerRepresentableAdaptator(
            searchsScrollView: searchsScrollView,
            handleValue: handleValue,
            behavior: behavior,
            background: background
        )
        .overlayContent(content)
        .onPreferenceChange(DynamicOverlayDragHandlePreferenceKey.self, perform: { value in
            handleValue = value
        })
        .onPreferenceChange(DynamicOverlayScrollPreferenceKey.self, perform: { value in
            searchsScrollView = value
        })
        .overlayContainerCoordinateSpace()
    }
}

struct OverlayContainerRepresentableAdaptator<Background: View>: UIViewControllerRepresentable {

    let searchsScrollView: Bool
    let handleValue: DynamicOverlayDragHandle
    let behavior: DynamicOverlayBehaviorValue
    let background: Background

    private var animationController: DynamicOverlayContainerAnimationController {
        DynamicOverlayContainerAnimationController()
    }

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
        let contentController = UIHostingController(rootView: OverlayContentHostingView())
        contentController.view.backgroundColor = .clear
        let backgroundController = UIHostingController(rootView: background)
        backgroundController.view.backgroundColor = .clear
        return OverlayContainerCoordinator(
            layout: containerState.layout,
            animationController: animationController,
            background: backgroundController,
            content: contentController
        )
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        let controller = OverlayContainerViewController(style: .flexibleHeight)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        context.coordinator.notchChangeUpdateHandler = { notch in
            behavior.binding?.wrappedValue = notch
        }
        context.coordinator.translationUpdateHandler = { coordinator in
            let animation = animationController.animation(using: coordinator)
            let transaction = Transaction(animation: animation)
            let translation = OverlayTranslation(
                height: coordinator.targetTranslationHeight,
                transaction: transaction,
                isDragging: coordinator.isDragging,
                translationProgress: coordinator.translationProgress(),
                containerFrame: uiViewController.view.frame,
                velocity: coordinator.velocity,
                heightForNotchIndex: { coordinator.height(forNotchAt: $0) }
            )
            withTransaction(transaction) {
                behavior.block?(translation)
            }
        }
        context.coordinator.shouldStartDraggingOverlay = { container, point, coordinateSpace in
            if let overlay = container.topViewController, handleValue.spots.isEmpty && !searchsScrollView {
                let inOverlayPoint = overlay.view.convert(point, from: coordinateSpace)
                return overlay.view.frame.contains(inOverlayPoint)
            } else {
                let inContainerPoint = container.view.convert(point, from: coordinateSpace)
                return handleValue.contains(inContainerPoint)
            }
        }
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
