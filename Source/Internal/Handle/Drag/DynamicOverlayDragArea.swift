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

    static var `default`: DynamicOverlayDragArea {
        DynamicOverlayDragArea(area: .default)
    }

    var isEmpty: Bool {
        area.isEmpty
    }

    func contains(_ rect: CGRect) -> Bool {
        area.contains(rect)
    }

    func contains(_ point: CGPoint) -> Bool {
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
