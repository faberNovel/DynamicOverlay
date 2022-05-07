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

    static func dimension(for notch: TestNotch) -> NotchDimension {
        switch notch {
        case .min:
            return .fractional(0.3)
        case .max:
            return .fractional(0.5)
        }
    }
}

private enum TestNotch: CaseIterable, Equatable {
    case min, max
}

private typealias Behavior = MagneticNotchOverlayBehavior<TestNotch>

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

    func testContentModeValue() {
        var behavior = Behavior.empty()
        XCTAssertEqual(behavior.buildValue().contentAdjustmentMode, .none)
        behavior = behavior.contentAdjustmentMode(.none)
        XCTAssertEqual(behavior.buildValue().contentAdjustmentMode, .none)
        behavior = behavior.contentAdjustmentMode(.stretch)
        XCTAssertEqual(behavior.buildValue().contentAdjustmentMode, .stretch)
    }

    func testTranslationMapping() {
        let expectation = XCTestExpectation()
        let overlayTranslations = OverlayTranslation.translations()
        let expectedTranslations = Behavior.Translation.translations()
        XCTAssertEqual(overlayTranslations.count, expectedTranslations.count)
        expectation.expectedFulfillmentCount = overlayTranslations.count
        class Context {
            var translation: Behavior.Translation!
        }
        let context = Context()
        let action = { (translation: Behavior.Translation) in
            XCTAssertEqual(context.translation.containerSize, translation.containerSize)
            XCTAssertEqual(context.translation.height, translation.height)
            XCTAssertEqual(context.translation.progress, translation.progress)
            TestNotch.allCases.forEach {
                XCTAssertEqual(context.translation.height(for: $0), translation.height(for: $0))
            }
            expectation.fulfill()
        }
        zip(overlayTranslations, expectedTranslations).forEach { value, translation in
            context.translation = translation
            Behavior.empty().onTranslation(action).buildValue().block?(value)
        }
    }
}

private extension MagneticNotchOverlayBehavior.Translation where Notch == TestNotch {

    static func translations() -> [Self] {
        [
            Behavior.Translation(
                height: 30.0,
                transaction: Transaction(),
                progress: 0.0,
                containerSize: CGSize(width: 30.0, height: 30.0),
                heightForNotch: {
                    switch $0 {
                    case .max:
                        return 400
                    case .min:
                        return 200
                    }
                }
            ),
            Behavior.Translation(
                height: 30.0,
                transaction: Transaction(),
                progress: 0.0,
                containerSize: CGSize(width: 30.0, height: 30.0),
                heightForNotch: {
                    switch $0 {
                    case .max:
                        return 400
                    case .min:
                        return 200
                    }
                }
            ),
            Behavior.Translation(
                height: 30.0,
                transaction: Transaction(),
                progress: 0.5,
                containerSize: CGSize(width: 30.0, height: 30.0),
                heightForNotch: {
                    switch $0 {
                    case .max:
                        return 400
                    case .min:
                        return 200
                    }
                }
            ),
            Behavior.Translation(
                height: 10.0,
                transaction: Transaction(),
                progress: 1.0,
                containerSize: CGSize(width: 60.0, height: 90.0),
                heightForNotch: {
                    switch $0 {
                    case .max:
                        return 400
                    case .min:
                        return 200
                    }
                }
            )
        ]
    }
}

private extension OverlayTranslation {

    static func translations() -> [OverlayTranslation] {
        [
            OverlayTranslation(
                height: 30.0,
                transaction: Transaction(),
                isDragging: false,
                translationProgress: 0.0,
                containerFrame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)),
                velocity: .zero,
                heightForNotchIndex: { i -> CGFloat in
                    switch i {
                    case 0:
                        return 200.0
                    case 1:
                        return 400.0
                    default:
                        fatalError()
                    }
                }
            ),
            OverlayTranslation(
                height: 30.0,
                transaction: Transaction(),
                isDragging: false,
                translationProgress: -1.0,
                containerFrame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)),
                velocity: .zero,
                heightForNotchIndex: { i -> CGFloat in
                    switch i {
                    case 0:
                        return 200.0
                    case 1:
                        return 400.0
                    default:
                        fatalError()
                    }
                }
            ),
            OverlayTranslation(
                height: 30.0,
                transaction: Transaction(),
                isDragging: false,
                translationProgress: 0.5,
                containerFrame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)),
                velocity: .zero,
                heightForNotchIndex: { i -> CGFloat in
                    switch i {
                    case 0:
                        return 200.0
                    case 1:
                        return 400.0
                    default:
                        fatalError()
                    }
                }
            ),
            OverlayTranslation(
                height: 10.0,
                transaction: Transaction(),
                isDragging: false,
                translationProgress: 1.5,
                containerFrame: CGRect(origin: .zero, size: CGSize(width: 60.0, height: 90.0)),
                velocity: .zero,
                heightForNotchIndex: { i -> CGFloat in
                    switch i {
                    case 0:
                        return 200.0
                    case 1:
                        return 400.0
                    default:
                        fatalError()
                    }
                }
            )
        ]
    }
}

private extension Behavior {

    static func empty() -> Self {
        Behavior { Constant.dimension(for: $0) }
    }
}
