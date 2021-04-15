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

private class NotchTarget: ObservableObject {

    @Published private(set) var notch: Notch

    init(notch: Notch) {
        self.notch = notch
    }

    func move(to notch: Notch) {
        self.notch = notch
    }
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
    var target: NotchTarget
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
        .notchChange($target.notch)
    }
}

class NotchChangeOverlayTests: XCTestCase {

    class Context {
        var expectedHeight: CGFloat = 0.0
    }

    func testInitialMaxNotch() {
        expectNotchHeight(.max)
    }

    func testInitialMinNotch() {
        expectNotchHeight(.min)
    }

    func testNotchChange() {
        let context = Context()
        let target = NotchTarget(notch: .min)
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
            target.move(to: notch)
            renderer.render()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    private func expectNotchHeight(_ notch: Notch) {
        let expectation = XCTestExpectation()
        let target = NotchTarget(notch: notch)
        let view = NotchChangeView(target: target) { height in
            expectation.fulfill()
            XCTAssertEqual(height, Constants.height(for: notch))
        }
        ViewRenderer(view: view).render()
        wait(for: [expectation], timeout: 1.0)
    }
}
