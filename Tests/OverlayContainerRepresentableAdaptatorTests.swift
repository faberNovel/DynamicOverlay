//
//  OverlayContainerRepresentableAdaptatorTests.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 20/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
import OverlayContainer
@testable import DynamicOverlay

private struct AdaptatorParameters {
    let searchsScrollView: Bool
    let handleValue: DynamicOverlayDragHandle
    let behavior: DynamicOverlayBehaviorValue
}

class OverlayContainerRepresentableAdaptatorTests: XCTestCase {

    class Context {
        let container: OverlayContainerViewController
        let coordinator: OverlayContainerCoordinator

        var overlay: UIViewController {
            container.topViewController!
        }

        init(container: OverlayContainerViewController,
             coordinator: OverlayContainerCoordinator) {
            self.container = container
            self.coordinator = coordinator
        }

        func layout() {
            container.view.frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 400))
            container.view.layoutIfNeeded()
        }
    }

    func testViewControllersSetup() {
        let context = makeContext(
            for: AdaptatorParameters(
                searchsScrollView: false,
                handleValue: .default,
                behavior: DynamicOverlayBehaviorValue(notchDimensions: [0: .absolute(200.0)])
            )
        )
        context.layout()
        XCTAssertEqual(context.container.viewControllers.count, 2)
    }

    func testDefaultDraggingStart() {
        let context = makeContext(
            for: AdaptatorParameters(
                searchsScrollView: false,
                handleValue: .default,
                behavior: DynamicOverlayBehaviorValue(notchDimensions: [0: .absolute(200.0)])
            )
        )
        context.layout()
        let overlay = context.overlay
        let aboveOverlayPoint = CGPoint(x: 100, y: -10)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, aboveOverlayPoint, overlay.view),
            false
        )
        let inOverlayPoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, inOverlayPoint, overlay.view),
            true
        )
    }

    func testDisabledDraggingStart() {
        let context = makeContext(
            for: AdaptatorParameters(
                searchsScrollView: false,
                handleValue: DynamicOverlayDragHandle(spots: [.init(frame: .zero, isActive: false)]),
                behavior: DynamicOverlayBehaviorValue(notchDimensions: [0: .absolute(200.0)])
            )
        )
        context.layout()
        let aboveOverlayPoint = CGPoint(x: 100, y: -10)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, aboveOverlayPoint, context.overlay.view),
            false
        )
        let inOverlayPoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, inOverlayPoint, context.overlay.view),
            false
        )
    }

    func testEnabledDraggingStart() {
        let context = makeContext(
            for: AdaptatorParameters(
                searchsScrollView: false,
                handleValue: DynamicOverlayDragHandle(
                    spots: [
                        .init(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 300)), isActive: true)
                    ]
                ),
                behavior: DynamicOverlayBehaviorValue(notchDimensions: [0: .absolute(200.0)])
            )
        )
        context.layout()
        let inZonePoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, inZonePoint, context.overlay.view),
            true
        )
        let outZonePoint = CGPoint(x: 300, y: 100)
        XCTAssertEqual(
            context.coordinator.shouldStartDraggingOverlay!(context.container, outZonePoint, context.overlay.view),
            false
        )
    }

    func testOverlayMoveNotification() {
        var index = 0
        let context = makeContext(
            for: AdaptatorParameters(
                searchsScrollView: false,
                handleValue: .default,
                behavior: DynamicOverlayBehaviorValue(
                    notchDimensions: [0: .absolute(200.0), 1: .absolute(300.0)],
                    binding: Binding<Int>(get: { index }, set: { index = $0 })
                )
            )
        )
        context.layout()
        context.container.moveOverlay(toNotchAt: 1, animated: false)
        context.layout()
        XCTAssertEqual(index, 1)
    }

    func testNumberOfNotches() {
        let dimensions: [[Int: NotchDimension]] = [
            [0: .absolute(200)],
            [0: .absolute(200), 1: .absolute(300)],
            [0: .absolute(200), 1: .absolute(300), 3: .absolute(400)],
        ]
        dimensions.forEach { layout in
            let context = makeContext(
                for: AdaptatorParameters(
                    searchsScrollView: false,
                    handleValue: .default,
                    behavior: DynamicOverlayBehaviorValue(
                        notchDimensions: layout,
                        binding: nil
                    )
                )
            )
            context.layout()
            XCTAssertEqual(
                context.container.delegate?.numberOfNotches(in: context.container) ?? 0,
                layout.count
            )
        }
    }

    func testDisabledNotches() {
        let all: [Int] = [0, 1, 2]
        let indexes: [Set<Int>] = [
            [],
            [0],
            [0, 1],
            [0, 1, 2],
            [2],
        ]
        indexes.forEach { disabledIndexes in
            let context = makeContext(
                for: AdaptatorParameters(
                    searchsScrollView: false,
                    handleValue: .default,
                    behavior: DynamicOverlayBehaviorValue(
                        notchDimensions: Dictionary(uniqueKeysWithValues: all.map { ($0, .absolute(100 * Double($0))) }),
                        binding: nil,
                        disabledNotchIndexes: disabledIndexes
                    )
                )
            )
            context.layout()
            Set(all).subtracting(disabledIndexes).forEach { index in
                XCTAssertEqual(
                    context.container.delegate?.overlayContainerViewController(
                        context.container,
                        canReachNotchAt: index,
                        forOverlay: context.overlay
                    ) ?? false,
                    true
                )
            }
            disabledIndexes.forEach { index in
                XCTAssertEqual(
                    context.container.delegate?.overlayContainerViewController(
                        context.container,
                        canReachNotchAt: index,
                        forOverlay: context.overlay
                    ) ?? true,
                    false
                )
            }
        }
    }

    private func makeContext(for parameters: AdaptatorParameters) -> Context {
        let adaptator = OverlayContainerRepresentableAdaptator(
            searchsScrollView: parameters.searchsScrollView,
            handleValue: parameters.handleValue,
            behavior: parameters.behavior,
            content: ContentView(),
            background: Color.green
        )
        let coordinator = adaptator.makeCoordinator()
        let context = OverlayContainerRepresentableAdaptator<ContentView, Color>.Context(
            coordinator: coordinator,
            transaction: Transaction()
        )
        let container = adaptator.makeUIViewController(context: context)
        adaptator.updateUIViewController(container, context: context)
        return Context(container: container, coordinator: coordinator)
    }
}

private struct ContentView: View {

    var body: some View {
        List { Text("") }
    }
}

