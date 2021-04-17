//
//  DynamicOverlayDragHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayDragHandle: Equatable {

    struct Spot: Equatable {
        let frame: CGRect
        let isActive: Bool
    }

    private(set) var spots: [Spot]

    mutating func merge(_ handle: DynamicOverlayDragHandle) {
        spots += handle.spots
    }

    func contains(_ point: CGPoint) -> Bool {
        spots.contains { $0.frame.contains(point) && $0.isActive }
    }
}

extension DynamicOverlayDragHandle {

    static var `default`: DynamicOverlayDragHandle {
        DynamicOverlayDragHandle(spots: [])
    }
}

struct DynamicOverlayDragHandlePreferenceKey: PreferenceKey {

    typealias Value = DynamicOverlayDragHandle

    static var defaultValue: DynamicOverlayDragHandle = .default

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
