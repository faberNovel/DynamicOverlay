//
//  NotchChangeOverlayTests.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 10/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import XCTest
import DynamicOverlay

private enum Notch: CaseIterable, Equatable {
    case min
    case max
}

private struct Constants {

    static func height(for notch: Notch) -> CGFloat {
        switch notch {
        case .max:
            return 300.0
        case .min:
            return 200.0
        }
    }
}

private struct NotchChangeView: View {

    @ObservedObject
    var target: ValuePublisher<Notch>
    let onHeightChange: (CGFloat) -> Void

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green.onHeightChange(onHeightChange))
            .dynamicOverlayBehavior(behavior)
    }

    var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            .absolute(Double(Constants.height(for: notch)))
        }
        .notchChange($target.value)
    }
}

class NotchChangeOverlayTests: XCTestCase {

    func testInitialMaxNotch() {
        expectNotchHeight(.max)
    }

    func testInitialMinNotch() {
        expectNotchHeight(.min)
    }

    func testNotchChange() {
        class Context {
            var expectedHeight: CGFloat = 0.0
        }
        let context = Context()
        let target = ValuePublisher(Notch.min)
        var previousHeight: CGFloat = 0
        let notches: [Notch] = [.min, .max]
        let expectation = XCTestExpectation(description: "notch-change")
        expectation.expectedFulfillmentCount = notches.count
        let view = NotchChangeView(target: target) { height in
            guard previousHeight != height else { return }
            previousHeight = height
            expectation.fulfill()
            XCTAssertEqual(height, context.expectedHeight)
        }
        let renderer = ViewRenderer(view: view)
        notches.forEach { notch in
            context.expectedHeight = Constants.height(for: notch)
            target.update(notch)
            renderer.render()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    private func expectNotchHeight(_ notch: Notch) {
        let expectation = XCTestExpectation()
        let target = ValuePublisher(notch)
        let view = NotchChangeView(target: target) { height in
            expectation.fulfill()
            XCTAssertEqual(height, Constants.height(for: notch))
        }
        ViewRenderer(view: view).render()
        wait(for: [expectation], timeout: 1.0)
    }
}
