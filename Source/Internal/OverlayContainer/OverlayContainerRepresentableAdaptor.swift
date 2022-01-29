//
//  OverlayContainerRepresentableAdaptor.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 20/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import OverlayContainer

struct OverlayContainerRepresentableAdaptor<Content: View, Background: View> {

    class Context {
        let coordinator: OverlayContainerCoordinator
        let transaction: Transaction

        init(coordinator: OverlayContainerCoordinator, transaction: Transaction) {
            self.coordinator = coordinator
            self.transaction = transaction
        }
    }

    let drivingScrollViewProxy: DynamicOverlayScrollViewProxy
    let dragArea: DynamicOverlayDragArea
    let behavior: DynamicOverlayBehaviorValue
    let content: Content
    let background: Background

    private var animationController: DynamicOverlayContainerAnimationController {
        DynamicOverlayContainerAnimationController()
    }

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            drivingScrollViewProxy: drivingScrollViewProxy,
            notchIndex: behavior.binding?.wrappedValue,
            disabledNotches: behavior.disabledNotchIndexes,
            layout: OverlayContainerLayout(indexToDimension: behavior.notchDimensions ?? [:])
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        let contentController = UIHostingController(rootView: content)
        contentController.view.backgroundColor = .clear
        contentController.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentController.view.setContentHuggingPriority(.defaultLow, for: .vertical)
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
        let controller = OverlayContainerViewController(style: .expandableHeight)
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
                translationProgress: coordinator.overallTranslationProgress(),
                containerFrame: uiViewController.view.frame,
                velocity: coordinator.velocity,
                heightForNotchIndex: { coordinator.height(forNotchAt: $0) }
            )
            withTransaction(transaction) {
                behavior.block?(translation)
            }
        }
        context.coordinator.shouldStartDraggingOverlay = { container, point, coordinateSpace in
            guard let overlay = container.topViewController else { return false }
            let inOverlayPoint = overlay.view.convert(point, from: coordinateSpace)
            return dragArea.canDrag(at: inOverlayPoint)
        }
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
