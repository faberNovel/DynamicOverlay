//
//  MagneticNotchContentModeTests.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 07/05/2022.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
import DynamicOverlay

private enum Notch: CaseIterable, Equatable {
    case min
    case max
}

private struct NotchDimensionView: View {

    let behavior: MagneticNotchOverlayBehavior<Notch>
    let onHeightChange: (CGFloat) -> Void

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green.onHeightChange(onHeightChange))
            .dynamicOverlayBehavior(behavior)
    }
}

class MagneticNotchContentModeTests: XCTestCase {

    func testAdjustmentContentModes() {
        let resultByMode: [MagneticNotchOverlayBehavior<Notch>.ContentAdjustmentMode: CGFloat] = [
            .none: 200,
            .stretch: 100
        ]
        let behavior = MagneticNotchOverlayBehavior<Notch> { notch in
            switch notch {
            case .max:
                return .absolute(200)
            case .min:
                return .absolute(100)
            }
        }
        resultByMode.forEach { mode, result in
            let expectation = XCTestExpectation()
            let view = NotchDimensionView(
                behavior: behavior.contentAdjustmentMode(mode).notchChange(.constant(.min))
            ) { height in
                XCTAssertEqual(height, result)
                expectation.fulfill()
            }
            ViewRenderer(view: view).render()
            wait(for: [expectation], timeout: 0.3)
        }
    }
}
