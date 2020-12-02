//
//  ViewController.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import UIKit
import SwiftUI
import DynamicOverlay

class ViewController: UIHostingController<ContentView> {

    // MARK: - Life Cycle

    init() {
        super.init(rootView: ContentView())
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ContentView: View {

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green)
    }
}
