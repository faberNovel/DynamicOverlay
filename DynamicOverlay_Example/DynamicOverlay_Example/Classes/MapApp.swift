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

struct ContentView: View {
    @State var notch: Notch = .min
    @State var showContent2 = false

    enum Notch: CaseIterable, Equatable { case min }

    var body: some View {
        Color.white
            .dynamicOverlay(overlayView)
            .dynamicOverlayBehavior(behavior)
    }

    private var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { _ in .absolute(showContent2 ? 400 : 200) }
    }

    private var overlayView: some View {
        VStack(spacing: 0) {
            Color.blue.frame(height: 50).draggable()
            if showContent2 {
                OverlayContent(title: "Content 2", color: Color.yellow, action: { withAnimation { showContent2.toggle() }})
            } else {
                OverlayContent(title: "Content 1", color: Color.red, action: { withAnimation { showContent2.toggle() }})
            }
        }
    }
}

struct OverlayContent: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            color
            VStack {
                Text(title).font(.title)
                Button(action: action, label: { Text("Action") }).padding()
            }
        }
    }
}

@main
struct MapApp: App {

    @UIApplicationDelegateAdaptor(UIKitAppDelegate.self)
    private var delegate: UIKitAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
