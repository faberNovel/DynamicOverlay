//
//  NotchDimensionDynamicOverlayTests.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
import DynamicOverlay

private enum Notch: CaseIterable, Equatable {
    case min
}

private struct NotchDimensionView: View {

    let dimension: () -> NotchDimension
    let onHeightChange: (CGFloat) -> Void

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green.onHeightChange(onHeightChange))
            .dynamicOverlayBehavior(behavior)
    }

    var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { _ in
            dimension()
        }
    }
}

class NotchDimensionDynamicOverlayTests: XCTestCase {

    func testVariousDimensions() {
        class Context {
            var dimension: NotchDimension = .absolute(0)
            var expectedHeight: CGFloat = 0.0
            var expectation = XCTestExpectation()
        }
        let renderer = ViewRenderer(view: EmptyView())
        let resultByDimension: [NotchDimension: CGFloat] = [
            .absolute(-1) : 0.0,
            .absolute(0) : 0.0,
            .absolute(200.0) : 200.0,
            .fractional(-1.0) : 0.0,
            .fractional(0.0) : 0.0,
            .fractional(2.0) : renderer.safeBounds.height * 2.0,
            .fractional(0.5) : renderer.safeBounds.height * 0.5,
        ]
        resultByDimension.forEach { dimension, expectedHeight in
            let context = Context()
            let view = NotchDimensionView(dimension: { context.dimension }) { height in
                context.expectation.fulfill()
                XCTAssertEqual(context.expectedHeight.rounded(.up), height.rounded(.up))
            }
            context.expectedHeight = expectedHeight
            context.expectation = XCTestExpectation()
            context.dimension = dimension
            ViewRenderer(view: view).render()
            wait(for: [context.expectation], timeout: 0.3)
        }
    }
}
