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
        DrivingScrollViewWrapper(content: content)
            .preference(key: DynamicOverlayScrollPreferenceKey.self,
                        value: isActive)
    }
}

struct DrivingScrollViewWrapper<Content: View>: UIViewRepresentable {
    let content: Content

    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = .zero
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.view.accessibilityIdentifier = DrivingScrollViewViewModifier.drivingScrollviewIdentifier
        let wrapperForLayout = UIView()
        wrapperForLayout.addSubview(hostingController.view)
        return wrapperForLayout
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
