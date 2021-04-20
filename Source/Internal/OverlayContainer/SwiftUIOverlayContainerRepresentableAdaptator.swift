//
//  SwiftUIOverlayContainerRepresentableAdaptator.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import OverlayContainer

struct SwiftUIOverlayContainerRepresentableAdaptator<Content: View, Background: View>: UIViewControllerRepresentable {

    let adaptator: OverlayContainerRepresentableAdaptator<Content, Background>

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        adaptator.makeCoordinator()
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        adaptator.makeUIViewController(context: map(context))
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        adaptator.updateUIViewController(uiViewController, context: map(context))
    }

    private func map(_ context: Context) -> OverlayContainerRepresentableAdaptator<Content, Background>.Context {
        OverlayContainerRepresentableAdaptator<Content, Background>.Context(
            coordinator: context.coordinator,
            transaction: context.transaction
        )
    }
}
