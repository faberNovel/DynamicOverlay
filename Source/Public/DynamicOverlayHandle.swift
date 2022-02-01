//
//  DynamicOverlayHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    /// Defines the target as a draggable view.
    ///
    /// - parameter isActive: Boolean indicating whether the target is draggable.
    func draggable(_ isActive: Bool = true) -> some View {
        modifier(
            ActiveOverlayAreaViewModifier(
                key: DynamicOverlayDragAreaPreferenceKey.self,
                isActive: isActive
            )
        )
    }

    /// Defines the target as the container of a driving scroll view.
    /// When specified a driving scroll view coordinates its scrolling with the overlay translation.
    ///
    /// - parameter isActive: Boolean indicating whether the scroll view is active.
    func drivingScrollView(_ isActive: Bool = true) -> some View {
        modifier(
            ActiveOverlayAreaViewModifier(
                key: DynamicOverlayScrollViewProxyPreferenceKey.self,
                isActive: isActive
            )
        )
    }
}
