//
//  UIKitAppDelegate.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 18/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import UIKit

class UIKitAppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UITableView.appearance().backgroundColor = .systemBackground
        return true
    }
}
