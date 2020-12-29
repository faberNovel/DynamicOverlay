//
//  OverlayContainer+CoordinateSpace.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension CoordinateSpace {

    static var overlayContainer: CoordinateSpace {
        CoordinateSpace.named("OverlayContainer")
    }
}

extension View {

    func overlayContainerCoordinateSpace() -> some View {
        modifier(OverlayContainerCoordinateSpaceViewModifier())
    }
}

struct OverlayContainerCoordinateSpaceViewModifier: ViewModifier {

    func body(content: Content) -> some View {
        content.coordinateSpace(name: "OverlayContainer")
    }
}
