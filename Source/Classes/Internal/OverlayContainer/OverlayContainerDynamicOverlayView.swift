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
    let transition: DynamicOverlayTransitionValue

    var body: some View {
        OverlayContainerRepresentableAdaptator(
            transition: transition
        )
        .overlayContent(content)
    }
}

struct OverlayContainerRepresentableAdaptator: UIViewControllerRepresentable {

    let transition: DynamicOverlayTransitionValue

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            notchIndex: transition.binding?.wrappedValue,
            layout: OverlayContainerLayout(indexToDimension: transition.notchDimensions ?? [:])
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        let coordinator = OverlayContainerCoordinator(
            initialState: containerState,
            content: UIHostingController(rootView: OverlayContentHostingView())
        )
        coordinator.notchChangeUpdateHandler = { notch in
            transition.binding?.wrappedValue = notch
        }
        coordinator.translationUpdateHandler = { coordinator in
            transition.block?(coordinator.targetTranslationHeight)
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
