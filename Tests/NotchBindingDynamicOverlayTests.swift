//
//  NotchBindingDynamicOverlayTests.swift
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
    let onFrameChange: (CGRect) -> Void

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green.onFrameChange(onFrameChange))
            .dynamicOverlayBehavior(behavior)
    }

    var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            .absolute(Double(Constants.height(for: notch)))
        }
        .notchChange($target.value)
    }
}

class NotchBindingDynamicOverlayTests: XCTestCase {

    func testInitialMaxNotch() {
        expectNotchHeight(.max)
    }

    func testInitialMinNotch() {
        expectNotchHeight(.min)
    }

    func testNotchChange() {
        class Context {
            var expectedHeight: CGFloat = 0.0
            var current = Notch.min
            var displayedFrame = CGRect.zero
            var expectations: [Notch: XCTestExpectation] = [:]
        }
        let target = ValuePublisher(Notch.min)
        let notches: [Notch] = [.min, .max]
        let context = Context()
        context.expectations = Dictionary(uniqueKeysWithValues: notches.map { ($0, XCTestExpectation()) })
        let view = NotchChangeView(target: target) { rect in
            context.displayedFrame = rect
            context.expectations[context.current]?.fulfill()
        }
        let renderer = ViewRenderer(view: view)
        notches.forEach { notch in
            guard let expectation = context.expectations[notch] else { return }
            context.current = notch
            target.update(notch)
            renderer.render()
            wait(for: [expectation], timeout: 1.0)
            let overlayFrame = renderer.window.bounds.intersection(context.displayedFrame)
            XCTAssertEqual(overlayFrame.height, Constants.height(for: notch))
            context.displayedFrame = .zero
        }
    }

    private func expectNotchHeight(_ notch: Notch) {
        let target = ValuePublisher(notch)
        var displayedFrame: CGRect = .zero
        let view = NotchChangeView(target: target) { rect in
            displayedFrame = rect
        }
        let renderer = ViewRenderer(view: view)
        renderer.render()
        let overlayFrame = renderer.window.bounds.intersection(displayedFrame)
        XCTAssertEqual(overlayFrame.height, Constants.height(for: notch))
    }
}
