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

    func findScrollView(in top: UIView) -> UIScrollView? {
        top.findScrollView(in: self, coordinate: top)
    }

    func isIncluded(in rect: CGRect) -> Bool {
        spots.contains { rect.intersects($0.frame) && $0.isActive }
    }
}

private extension UIView {

    func findScrollView(in handle: DynamicOverlayDragHandle,
                        coordinate: UICoordinateSpace) -> UIScrollView? {
        let frame = coordinate.convert(bounds, from: self)
        guard handle.isIncluded(in: frame) else { return nil }
        if let result = self as? UIScrollView {
            return result
        }
        for subview in subviews {
            if let result = subview.findScrollView(in: handle, coordinate: coordinate) {
                return result
            }
        }
        return nil
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
