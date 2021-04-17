//
//  NotchTranslationDynamicOverlayTests.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 15/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import XCTest
@testable import DynamicOverlay

private enum Notch: CaseIterable, Equatable {
    case min, max
}

private struct Constants {

    static func insets(for layout: TranslationLayout) -> UIEdgeInsets {
        switch layout {
        case .compact:
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        case .full:
            return .zero
        }
    }

    static func height(for notch: Notch) -> CGFloat {
        switch notch {
        case .max:
            return 300.0
        case .min:
            return 100.0
        }
    }
}

private typealias OverlayTranslation = MagneticNotchOverlayBehavior<Notch>.Translation

private struct TranslationView: View {

    @ObservedObject
    var target: ValuePublisher<Notch>
    let onTranslation: (OverlayTranslation) -> Void

    var body: some View {
        Color.red
            .dynamicOverlay(Color.green)
            .dynamicOverlayBehavior(behavior)
    }

    private var behavior: MagneticNotchOverlayBehavior<Notch> {
        MagneticNotchOverlayBehavior { notch in
            .absolute(Double(Constants.height(for: notch)))
        }
        .notchChange($target.value)
        .onTranslation(onTranslation)
    }
}

private enum TranslationLayout {
    case full, compact
}

private struct TranslationContainerView: View {

    let layout: TranslationLayout
    @ObservedObject
    var target: ValuePublisher<Notch>
    let onTranslation: (OverlayTranslation) -> Void

    var body: some View {
        TranslationView(
            target: target,
            onTranslation: onTranslation
        )
        .padding(insets)
    }

    private var insets: EdgeInsets {
        let layoutInsets = Constants.insets(for: layout)
        return EdgeInsets(
            top: layoutInsets.top,
            leading: layoutInsets.left,
            bottom: layoutInsets.bottom,
            trailing: layoutInsets.bottom
        )
    }
}

class NotchTranslationDynamicOverlayTests: XCTestCase {

    func testInitialTranslation() {
        class Context {
            var expectedTranslation = OverlayTranslation.none
        }
        let context = Context()
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = Notch.allCases.count
        Notch.allCases.forEach { notch in
            let target = ValuePublisher(notch)
            let view = TranslationView(target: target) { translation in
                expectation.fulfill()
                self.expect(translation, toEqual: context.expectedTranslation)
            }
            let renderer = ViewRenderer(view: view)
            context.expectedTranslation = .initial(for: notch, in: renderer.safeBounds)
            renderer.render()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testNotchMovesTranslation() {
        class Context {
            var expectedTranslation = OverlayTranslation.none
            var expectation = XCTestExpectation()
        }
        let context = Context()
        let target = ValuePublisher(Notch.min)
        let view = TranslationView(target: target) { translation in
            context.expectation.fulfill()
            self.expect(translation, toEqual: context.expectedTranslation)
        }
        // Initial
        let renderer = ViewRenderer(view: view)
        context.expectedTranslation = .initial(for: .min, in: renderer.safeBounds)
        renderer.render()
        wait(for: [context.expectation], timeout: 0.3)
        // Max not animated
        context.expectation = XCTestExpectation()
        context.expectedTranslation = .moved(to: .max, animated: false, in: renderer.safeBounds)
        target.update(.max)
        wait(for: [context.expectation], timeout: 0.3)
        // Min animated
        context.expectation = XCTestExpectation()
        context.expectedTranslation = .moved(to: .min, animated: true, in: renderer.safeBounds)
        withAnimation {
            target.update(.min)
        }
        wait(for: [context.expectation], timeout: 0.3)
    }

    func testLayoutChangesTranslation() {
        class Context {
            var expected = OverlayTranslation.none
        }
        let layouts: [TranslationLayout] = [.compact, .full]
        layouts.forEach { layout in
            let context = Context()
            let expectation = XCTestExpectation()
            let target = ValuePublisher(Notch.min)
            let view = TranslationContainerView(
                layout: layout,
                target: target,
                onTranslation: { translation in
                    expectation.fulfill()
                    self.expect(translation, toEqual: context.expected)
                }
            )
            let renderer = ViewRenderer(view: view)
            context.expected = .layout(layout, in: renderer.safeBounds)
            renderer.render()
            wait(for: [expectation], timeout: 0.3)
        }
    }

    // MARK: - Private

    private func expect(_ lhs: OverlayTranslation, toEqual rhs: OverlayTranslation) {
        XCTAssertEqual(lhs.containerSize, rhs.containerSize)
        XCTAssertEqual(lhs.progress, rhs.progress)
        XCTAssertEqual(lhs.height, rhs.height)
        let lhsHasAnimation = lhs.transaction.animation != nil
        let rhsHasAnimation = rhs.transaction.animation != nil
        XCTAssertEqual(lhsHasAnimation, rhsHasAnimation)
        Notch.allCases.forEach {
            XCTAssertEqual(lhs.height(for: $0), rhs.height(for: $0))
        }
    }
}

private extension OverlayTranslation {

    static var none: OverlayTranslation {
        OverlayTranslation(height: 0, transaction: Transaction(), progress: 0, containerSize: .zero, heightForNotch: { _ in 0 })
    }

    static func initial(for notch: Notch, in bounds: CGRect) -> OverlayTranslation {
        .notch(notch, animated: false, in: bounds)
    }

    static func moved(to notch: Notch, animated: Bool, in bounds: CGRect) -> OverlayTranslation {
        .notch(notch, animated: animated, in: bounds)
    }

    static func layout(_ layout: TranslationLayout, in bounds: CGRect) -> OverlayTranslation {
        OverlayTranslation(
            height: Constants.height(for: .min),
            transaction: Transaction(),
            progress: 0.0,
            containerSize: bounds.inset(by: Constants.insets(for: layout)).size,
            heightForNotch: Constants.height(for:)
        )
    }

    private static func notch(_ notch: Notch, animated: Bool, in bounds: CGRect) -> OverlayTranslation {
        OverlayTranslation(
            height: Constants.height(for: notch),
            transaction: Transaction(animation: animated ? .default : nil),
            progress: notch == .max ? 1.0 : 0.0,
            containerSize: bounds.size,
            heightForNotch: Constants.height(for:)
        )
    }
}
