//
//  OverlayContainerRepresentableAdaptorTests.swift
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

private struct AdaptorParameters {
    var drivingHandle: DynamicOverlayScrollViewProxy
    var handleValue: DynamicOverlayDragArea
    var disabledNotches: Set<Int> = []
    var indexToDimension: [Int: NotchDimension] = [:]
    var onIndexChange: ((Int) -> Void)?
}

class OverlayContainerRepresentableAdaptorTests: XCTestCase {

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
            for: AdaptorParameters(
                drivingHandle: .default,
                handleValue: .default,
                indexToDimension: [0: .absolute(200.0)]
            )
        )
        context.layout()
        XCTAssertEqual(context.container.viewControllers.count, 2)
    }

    func testDefaultDraggingStart() {
        let context = makeContext(
            for: AdaptorParameters(
                drivingHandle: .default,
                handleValue: .default,
                indexToDimension: [0: .absolute(200.0)]
            )
        )
        context.layout()
        let aboveOverlayPoint = CGPoint(x: 100, y: -10)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: aboveOverlayPoint,
                in: context.overlay.view
            ),
            false
        )
        let inOverlayPoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: inOverlayPoint,
                in: context.overlay.view
            ),
            true
        )
    }

    func testDisabledDraggingStart() {
        let context = makeContext(
            for: AdaptorParameters(
                drivingHandle: .default,
                handleValue: DynamicOverlayDragArea(area: .inactive()),
                indexToDimension: [0: .absolute(200.0)]
            )
        )
        context.layout()
        let aboveOverlayPoint = CGPoint(x: 100, y: -10)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: aboveOverlayPoint,
                in: context.overlay.view
            ),
            false
        )
        let inOverlayPoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: inOverlayPoint,
                in: context.overlay.view
            ),
            false
        )
    }

    func testEnabledDraggingStart() {
        let context = makeContext(
            for: AdaptorParameters(
                drivingHandle: .default,
                handleValue: DynamicOverlayDragArea(
                    area: .active(CGRect(origin: .zero, size: CGSize(width: 200, height: 300)))
                ),
                indexToDimension: [0: .absolute(200.0)]
            )
        )
        context.layout()
        let inZonePoint = CGPoint(x: 100, y: 100)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: inZonePoint,
                in: context.overlay.view
            ),
            true
        )
        let outZonePoint = CGPoint(x: 300, y: 100)
        XCTAssertEqual(
            context.container.delegate?.overlayContainerViewController(
                context.container,
                shouldStartDraggingOverlay: context.overlay,
                at: outZonePoint,
                in: context.overlay.view
            ),
            false
        )
    }

    func testOverlayMoveNotification() {
        var index = 0
        let context = makeContext(
            for: AdaptorParameters(
                drivingHandle: .default,
                handleValue: DynamicOverlayDragArea(area: .default),
                indexToDimension: [0: .absolute(200.0), 1: .absolute(300.0)],
                onIndexChange: { index = $0 }
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
                for: AdaptorParameters(
                    drivingHandle: .default,
                    handleValue: .default,
                    indexToDimension: layout
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
                for: AdaptorParameters(
                    drivingHandle: .default,
                    handleValue: .default,
                    disabledNotches: disabledIndexes,
                    indexToDimension: Dictionary(uniqueKeysWithValues: all.map { ($0, .absolute(100 * Double($0))) })
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

    private func makeContext(for parameters: AdaptorParameters) -> Context {
        let holder = OverlayContainerPassiveContainer()
        holder.onNotchChange = parameters.onIndexChange
        let adaptor = OverlayContainerRepresentableAdaptor.init(
            containerState: OverlayContainerState(
                dragArea: parameters.handleValue,
                drivingScrollViewProxy: parameters.drivingHandle,
                notchIndex: nil,
                disabledNotches: parameters.disabledNotches,
                layout: OverlayContainerLayout(indexToDimension: parameters.indexToDimension),
                contentAdjustmentMode: .none
            ),
            passiveContainer: holder,
            content: ContentView(),
            background: Color.green
        )
        let coordinator = adaptor.makeCoordinator()
        let context = OverlayContainerRepresentableAdaptor<ContentView, Color>.Context(
            coordinator: coordinator,
            transaction: Transaction()
        )
        let container = adaptor.makeUIViewController(context: context)
        adaptor.updateUIViewController(container, context: context)
        return Context(container: container, coordinator: coordinator)
    }
}

private struct ContentView: View {

    var body: some View {
        List { Text("") }
    }
}

