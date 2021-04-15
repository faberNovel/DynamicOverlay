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
        targetWindow.frame.size
    }

    private var targetWindow: UIWindow {
        UIApplication.shared.windows.first!
    }

    private let hostController: UIHostingController<V>

    init(view: V) {
        self.hostController = UIHostingController(rootView: view)
    }

    func render() {
        if targetWindow.rootViewController !== hostController {
            targetWindow.rootViewController = hostController
        }
        CATransaction.flush()
    }
}
