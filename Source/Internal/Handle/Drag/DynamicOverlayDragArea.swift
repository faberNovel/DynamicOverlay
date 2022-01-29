//
//  DynamicOverlayDragArea.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 29/01/2022.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

struct DynamicOverlayDragArea {

    private let area: ActivatedOverlayArea

    init(area: ActivatedOverlayArea) {
        self.area = area
    }

    static var empty: DynamicOverlayDragArea {
        DynamicOverlayDragArea(area: .empty)
    }

    func canDrag(at point: CGPoint) -> Bool {
        if area.isZero {
            return true
        }
        return area.contains(point)
    }
}

struct DynamicOverlayDragAreaPreferenceKey: PreferenceKey {

    typealias Value = ActivatedOverlayArea

    static var defaultValue: ActivatedOverlayArea = .default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}
