//
//  DrivingScrollViewHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 11/01/2022.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayScrollPreferenceKey: PreferenceKey {

    typealias Value = DynamicOverlayDragHandle

    static var defaultValue: DynamicOverlayDragHandle = .default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}
