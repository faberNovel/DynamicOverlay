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
            content: content,
            transition: transition
        )
    }
}

struct OverlayContainerRepresentableAdaptator<Content: View>: UIViewControllerRepresentable {

    let content: Content
    let transition: DynamicOverlayTransitionValue

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            notchIndex: transition.binding?.wrappedValue,
            layout: OverlayContainerLayout(indexToDimension: transition.notchDimensions ?? [:]),
            content: UIHostingController(rootView: content)
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        let coordinator = OverlayContainerCoordinator(
            initialState: OverlayContainerState(
                notchIndex: nil,
                layout: containerState.layout,
                content: nil
            )
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
        let controller = OverlayContainerViewController(style: .expandableHeight)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
