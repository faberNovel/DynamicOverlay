//
//  OverlayContainer+CoordinateSpace.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension CoordinateSpace {

    static var overlay: CoordinateSpace {
        .named("Overlay")
    }
}

extension View {

    func overlayCoordinateSpace() -> some View {
        modifier(OverlayCoordinateSpaceViewModifier())
    }
}

struct OverlayCoordinateSpaceViewModifier: ViewModifier {

    func body(content: Content) -> some View {
        content.coordinateSpace(name: "Overlay")
    }
}
