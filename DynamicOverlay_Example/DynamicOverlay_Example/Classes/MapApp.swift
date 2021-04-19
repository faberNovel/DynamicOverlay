//
//  MapApp.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import UIKit
import SwiftUI
import DynamicOverlay

@main
struct MapApp: App {

    @UIApplicationDelegateAdaptor(UIKitAppDelegate.self)
    private var delegate: UIKitAppDelegate

    var body: some Scene {
        WindowGroup {
            MapRootView()
        }
    }
}
