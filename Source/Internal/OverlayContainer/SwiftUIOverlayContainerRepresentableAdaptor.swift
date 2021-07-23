//
//  SwiftUIOverlayContainerRepresentableAdaptor.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import OverlayContainer

struct SwiftUIOverlayContainerRepresentableAdaptor<Content: View, Background: View>: UIViewControllerRepresentable {

    let adaptor: OverlayContainerRepresentableAdaptor<Content, Background>

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        adaptor.makeCoordinator()
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        adaptor.makeUIViewController(context: map(context))
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        adaptor.updateUIViewController(uiViewController, context: map(context))
    }

    private func map(_ context: Context) -> OverlayContainerRepresentableAdaptor<Content, Background>.Context {
        OverlayContainerRepresentableAdaptor<Content, Background>.Context(
            coordinator: context.coordinator,
            transaction: context.transaction
        )
    }
}
