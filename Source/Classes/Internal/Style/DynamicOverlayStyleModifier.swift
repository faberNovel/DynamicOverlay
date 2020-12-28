//
//  DynamicOverlayStyleModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

enum OverlayStyle {
    case shrinkable
}

public struct DynamicOverlayStyleModifier: ViewModifier {

    let style: OverlayStyle

    public func body(content: Content) -> some View {
        content.environment(\.overlayStyle, style)
    }
}

struct DynamicOverlayStyleKey: EnvironmentKey {

    static var defaultValue: OverlayStyle = .shrinkable
}

extension EnvironmentValues {

    var overlayStyle: OverlayStyle {
        set {
            self[DynamicOverlayStyleKey] = newValue
        }
        get {
            self[DynamicOverlayStyleKey]
        }
    }
}
