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

    struct Context {
        let coordinator: OverlayContainerCoordinator
        let transaction: Transaction
    }

    let containerState: OverlayContainerState
    let passiveContainer: OverlayContainerPassiveContainer
    let content: Content
    let background: Background

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
            passiveContainer: passiveContainer,
            background: backgroundController,
            content: contentController
        )
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        let controller = OverlayContainerViewController(style: .expandableHeight)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ container: OverlayContainerViewController,
                                context: Context) {
        context.coordinator.move(
            container,
            to: containerState,
            animated: context.transaction.animation != nil
        )
    }
}
