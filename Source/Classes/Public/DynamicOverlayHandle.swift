//
//  DynamicOverlayHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dragHandle(_ isActive: Bool = true) -> some View {
        modifier(DragHandleViewModifier(isActive: isActive))
    }

    func drivingScrollView(_ isActive: Bool = true) -> some View {
        modifier(DrivingScrollViewViewModifier(isActive: isActive))
    }
}
