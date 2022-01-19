//
//  DrivingScrollViewViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DrivingScrollViewViewModifier: ViewModifier {

    @State
    private var viewController = DrivingScrollViewViewController()

    let isActive: Bool

    func body(content: Content) -> some View {
        DrivingScrollViewWrapper(container: viewController, content: content)
            .preference(
                key: DynamicOverlayScrollPreferenceKey.self,
                value: isActive ? .active(viewController) : .inactive()
            )
    }
}

private struct DrivingScrollViewWrapper<Content: View>: UIViewControllerRepresentable {

    let container: DrivingScrollViewViewController
    let content: Content

    func makeUIViewController(context: Self.Context) -> DrivingScrollViewViewController {
        container.setContent(content)
        return container
    }

    func updateUIViewController(_ controller: DrivingScrollViewViewController, context: Self.Context) {}
}

private class DrivingScrollViewViewController: UIViewController, ScrollViewContainer {

    func setContent<Content: View>(_ content: Content) {
        let hostingController = UIHostingController(rootView: content)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.backgroundColor = .clear
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }

    func scrollView() -> UIScrollView? {
        view.findScrollView()
    }
}

private extension UIView {

    func findScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        for subview in subviews {
            if let target = subview.findScrollView() {
                return target
            }
        }
        return nil
    }
}
