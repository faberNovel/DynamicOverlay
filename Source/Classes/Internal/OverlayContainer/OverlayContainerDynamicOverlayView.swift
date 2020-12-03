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

    let content: Content
    let behavior: DynamicOverlayBehaviorValue

    var body: some View {
        OverlayContainerRepresentableAdaptator(
            behavior: behavior
        )
        .passThroughContent()
        .overlayContent(content)
    }
}

struct OverlayContainerRepresentableAdaptator: UIViewControllerRepresentable {

    let behavior: DynamicOverlayBehaviorValue

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            notchIndex: behavior.binding?.wrappedValue,
            disabledNotches: behavior.disabledNotchIndexes,
            layout: OverlayContainerLayout(indexToDimension: behavior.notchDimensions ?? [:])
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        let coordinator = OverlayContainerCoordinator(
            layout: containerState.layout,
            content: UIHostingController(rootView: OverlayContentHostingView())
        )
        coordinator.notchChangeUpdateHandler = { notch in
            behavior.binding?.wrappedValue = notch
        }
        coordinator.translationUpdateHandler = { coordinator in
            behavior.block?(coordinator.targetTranslationHeight)
        }
        return coordinator
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        let controller = OverlayContainerViewController(style: .flexibleHeight)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
