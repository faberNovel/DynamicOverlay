//
//  DrivingScrollViewViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DrivingScrollViewViewModifier: ViewModifier {

    let isActive: Bool

    func body(content: Content) -> some View {
        DrivingScrollViewWrapper(content: content)
            .preference(key: DynamicOverlayScrollPreferenceKey.self,
                        value: isActive)
    }
}

struct DrivingScrollViewWrapper<Content: View>: UIViewRepresentable {
    let content: Content

    func makeUIView(context: Context) -> DrivingScrollViewMarkingWrapper {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = .zero
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return DrivingScrollViewMarkingWrapper(content: hostingController.view)
    }

    func updateUIView(_ uiView: DrivingScrollViewMarkingWrapper, context: Context) {}
}

class DrivingScrollViewMarkingWrapper: UIView {

    init(content: UIView, frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(content)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
