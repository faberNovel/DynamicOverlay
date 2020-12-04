//
//  DynamicOverlayHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    func dragHandle() -> some View {
        anchorPreference(key: DynamicOverlayDragHandlePreferenceKey.self, value: .bounds) {
            DynamicOverlayDragHandle(anchors: [$0])
        }
    }

    func drivingScrollView() -> some View {
        preference(key: DynamicOverlayScrollPreferenceKey.self, value: true)
    }
}
