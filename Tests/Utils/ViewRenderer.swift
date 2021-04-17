//
//  ViewRenderer.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 12/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

class ViewRenderer<V: View> {

    var size: CGSize {
        window.frame.size
    }

    var safeAreaInsets: UIEdgeInsets {
        window.safeAreaInsets
    }

    var bounds: CGRect {
        window.bounds
    }

    var safeBounds: CGRect {
        bounds.inset(by: safeAreaInsets)
    }

    var window: UIWindow {
        UIApplication.shared.windows.first!
    }

    private let hostController: UIHostingController<V>

    init(view: V) {
        self.hostController = UIHostingController(rootView: view)
    }

    func render() {
        if window.rootViewController !== hostController {
            window.rootViewController = hostController
        }
        CATransaction.flush()
    }
}
