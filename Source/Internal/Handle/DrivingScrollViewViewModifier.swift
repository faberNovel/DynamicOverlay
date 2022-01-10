//
//  DrivingScrollViewViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DrivingScrollViewViewModifier: ViewModifier {
    static let drivingScrollviewIdentifier = "DynamicOverlay_DrivingScrollerView"

    let isActive: Bool

    func body(content: Content) -> some View {
        DrivingScrollViewWrapper(content: ZStack { content })
            .preference(key: DynamicOverlayScrollPreferenceKey.self,
                        value: isActive)
    }
}

struct DrivingScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
    let content: Content

    func makeUIViewController(context: Self.Context) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = .zero
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.view.accessibilityIdentifier = DrivingScrollViewViewModifier.drivingScrollviewIdentifier
        return hostingController
    }

    func updateUIViewController(_ controller: UIHostingController<Content>, context: Self.Context) {

    }
}
