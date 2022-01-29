//
//  DynamicOverlayScrollViewProxyPreferenceKey.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 11/01/2022.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import SwiftUI

struct DynamicOverlayScrollViewProxy: Equatable {

    private let area: ActivatedOverlayArea

    init(area: ActivatedOverlayArea) {
        self.area = area
    }

    static var none: DynamicOverlayScrollViewProxy {
        DynamicOverlayScrollViewProxy(area: .empty)
    }

    func findScrollView(in space: UIView) -> UIScrollView? {
        space.findScrollView(in: area, coordinate: space)
    }
}


struct DynamicOverlayScrollViewProxyPreferenceKey: PreferenceKey {

    typealias Value = ActivatedOverlayArea

    static var defaultValue: ActivatedOverlayArea = .default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}

private extension UIView {

    func findScrollView(in area: ActivatedOverlayArea,
                        coordinate: UICoordinateSpace) -> UIScrollView? {
        let frame = coordinate.convert(bounds, from: self)
        guard area.isIncluded(in: frame) else { return nil }
        if let result = self as? UIScrollView {
            return result
        }
        for subview in subviews {
            if let result = subview.findScrollView(in: area, coordinate: coordinate) {
                return result
            }
        }
        return nil
    }
}
