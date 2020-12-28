//
//  DynamicOverlayDragHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayDragHandle: Equatable {

    struct Value: Equatable {
        let frame: CGRect
        let isActive: Bool
    }

    var values: [Value]

    mutating func merge(_ handle: DynamicOverlayDragHandle) {
        values += handle.values
    }
}

struct DynamicOverlayDragHandlePreferenceKey: PreferenceKey {

    typealias Value = DynamicOverlayDragHandle

    static var defaultValue = DynamicOverlayDragHandle(values: [])

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
