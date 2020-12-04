//
//  DynamicOverlayDragHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayDragHandle: Equatable {

    var anchors: [Anchor<CGRect>]

    mutating func merge(_ handle: DynamicOverlayDragHandle) {
        anchors += handle.anchors
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        false // I don't know what to put here. Apple removed the `Anchor` Equatable conformance.
    }
}

struct DynamicOverlayDragHandlePreferenceKey: PreferenceKey {

    typealias Value = DynamicOverlayDragHandle

    static var defaultValue = DynamicOverlayDragHandle(anchors: [])

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}

struct DynamicOverlayScrollPreferenceKey: PreferenceKey {

    static var defaultValue = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue() ? true : value
    }
}
