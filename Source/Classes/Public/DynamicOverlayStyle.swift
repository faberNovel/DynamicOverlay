//
//  DynamicOverlayStyle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public protocol DynamicOverlayStyle {

    func makeModifier() -> DynamicOverlayStyleModifier
}

public struct ShrinkableDynamicOverlayStyle: DynamicOverlayStyle {

    public init() {}

    public func makeModifier() -> DynamicOverlayStyleModifier {
        DynamicOverlayStyleModifier(style: .shrinkable)
    }
}

public extension View {

    func dynamicOverlayStyle<Style: DynamicOverlayStyle>(_ style: Style) -> some View {
        modifier(style.makeModifier())
    }
}
