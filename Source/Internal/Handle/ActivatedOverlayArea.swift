//
//  ActivatedOverlayArea.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 04/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct ActivatedOverlayArea: Equatable {

    private struct Spot: Equatable {
        let frame: CGRect
    }

    private var spots: [Spot]

    mutating func merge(_ handle: ActivatedOverlayArea) {
        spots += handle.spots
    }

    var isEmpty: Bool {
        spots.isEmpty
    }

    func contains(_ rect: CGRect) -> Bool {
        spots.contains { $0.frame == rect }
    }

    func contains(_ point: CGPoint) -> Bool {
        spots.contains { $0.frame.contains(point) }
    }

    func intersects(_ rect: CGRect) -> Bool {
        spots.contains {
            // (gz) 2022-01-29 `SwiftUI` rounds the `UIKit` view frames.
            // A 0.25pt-width `SwiftUI` view can contain a 0.5pt-width `UIView`.
            rect.intersection($0.frame).width >= 0.5
            && $0.frame != .zero
        }
    }
}

extension ActivatedOverlayArea {

    static func active(_ frame: CGRect) -> ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [Spot(frame: frame)])
    }

    static func inactive() -> ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [Spot(frame: .zero)])
    }

    static var `default`: ActivatedOverlayArea {
        .empty
    }

    static var empty: ActivatedOverlayArea {
        ActivatedOverlayArea(spots: [])
    }
}
