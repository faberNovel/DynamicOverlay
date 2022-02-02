//
//  OnDragAreaChangeViewModifier.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

private struct OnDragAreaChangeViewModifier: ViewModifier {

    let handler: (DynamicOverlayDragArea) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(DynamicOverlayDragAreaPreferenceKey.self) { area in
            handler(DynamicOverlayDragArea(area: area))
        }
    }
}

extension View {

    func onDragAreaChange(handler: @escaping (DynamicOverlayDragArea) -> Void) -> some View {
        modifier(OnDragAreaChangeViewModifier(handler: handler))
    }
}
