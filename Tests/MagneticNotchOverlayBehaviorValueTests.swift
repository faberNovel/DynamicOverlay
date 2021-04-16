//
//  MagneticNotchOverlayBehaviorValueTests.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
@testable import DynamicOverlay

private enum Constant {

    static func dimension(for notch: Notch) -> NotchDimension {
        switch notch {
        case .min:
            return .fractional(0.3)
        case .max:
            return .fractional(0.5)
        }
    }
}

private enum Notch: CaseIterable, Equatable {
    case min, max
}

private typealias Behavior = MagneticNotchOverlayBehavior<Notch>

class MagneticNotchOverlayBehaviorValueTests: XCTestCase {

    func testDisabledIndexesOverlayValue() {
        var behavior = Behavior.empty()
        XCTAssertEqual(behavior.buildValue().disabledNotchIndexes, [])
        behavior = behavior.disable(.min)
        XCTAssertEqual(behavior.buildValue().disabledNotchIndexes, [0])
        behavior = behavior.disable(.max)
        XCTAssertEqual(behavior.buildValue().disabledNotchIndexes, [0, 1])
    }

    func testNotchChangeOverlayValue() {
        var behavior = Behavior.empty()
        XCTAssertTrue(behavior.buildValue().binding == nil)
        behavior = behavior.notchChange(.constant(.min))
        XCTAssertTrue(behavior.buildValue().binding?.wrappedValue == 0)
        behavior = behavior.notchChange(.constant(.max))
        XCTAssertTrue(behavior.buildValue().binding?.wrappedValue == 1)
    }

    func testNotchDimensionOverlayValue() {
        XCTAssertEqual(
            Behavior.empty().buildValue().notchDimensions,
            [
                0: Constant.dimension(for: .min),
                1: Constant.dimension(for: .max),
            ]
        )
    }

    func testBlockOverlayValue() {
        var behavior = Behavior.empty()
        XCTAssertTrue(behavior.buildValue().block == nil)
        behavior = behavior.onTranslation { _ in }
        XCTAssertTrue(behavior.buildValue().block != nil)
        behavior = behavior.onTranslation { _ in }
        XCTAssertTrue(behavior.buildValue().block != nil)
    }
}

private extension Behavior {

    static func empty() -> Self {
        Behavior { Constant.dimension(for: $0) }
    }
}
