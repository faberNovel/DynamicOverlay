//
//  ActivatedOverlayArea.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct ActivatedOverlayArea: Equatable {

    struct Spot: Equatable {
        let frame: CGRect
    }

    private var spots: [Spot]

    mutating func merge(_ handle: ActivatedOverlayArea) {
        spots += handle.spots
    }

    var isZero: Bool {
        spots.isEmpty
    }

    func contains(_ point: CGPoint) -> Bool {
        spots.contains { $0.frame.contains(point) }
    }

    func isIncluded(in rect: CGRect) -> Bool {
        spots.contains { rect.intersects($0.frame) }
    }
}


extension ActivatedOverlayArea {

    static func active(_ frame: CGRect) -> ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [Spot(frame: frame)])
    }

    static func inactive() -> ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [])
    }

    static var `default`: ActivatedOverlayArea {
        .empty
    }

    static var empty: ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [])
    }
}
