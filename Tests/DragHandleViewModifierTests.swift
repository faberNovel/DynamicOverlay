//
//  DragHandleTests.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
@testable import DynamicOverlay

private struct HandleView: View {

    var body: some View {
        Color.red
    }
}

private struct ContainerView: View {

    let isActive: Bool
    let frame: CGRect
    let handler: (DynamicOverlayDragHandle) -> Void

    var body: some View {
        GeometryReader { _ in
            HandleView()
                .frame(width: frame.width, height: frame.height)
                .draggable(isActive)
                .offset(x: frame.origin.x, y: frame.origin.y)
        }
        .onDragHandleChange(handler: handler)
        .overlayCoordinateSpace()
    }
}

private struct MultipleHandlesView: View {

    let handler: (DynamicOverlayDragHandle) -> Void

    var body: some View {
        VStack {
            Color.orange.draggable()
            Color.red.draggable()
        }
        .overlayCoordinateSpace()
        .onDragHandleChange(handler: handler)
    }
}

class DragHandleViewModifierTests: XCTestCase {

    func testActiveState() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let activeHandle = DynamicOverlayDragHandle(
            spots: [
                DynamicOverlayDragHandle.Spot(frame: frame, isActive: true)
            ]
        )
        let notActiveHandle = DynamicOverlayDragHandle(
            spots: [
                DynamicOverlayDragHandle.Spot(frame: frame, isActive: false)
            ]
        )
        let point = CGPoint(x: 20.0, y: 20.0)
        XCTAssertTrue(activeHandle.contains(point))
        XCTAssertFalse(notActiveHandle.contains(point))
    }

    func testMultipleFrames() {
        let values: [(Bool, CGRect)] = [
            (true, CGRect(x: 30, y: 30, width: 50, height: 100)),
            (false, CGRect(x: 0, y: 0, width: 400, height: 400)),
        ]
        values.forEach { isActive, frame in
            let expectation = XCTestExpectation()
            let view = ContainerView(
                isActive: isActive,
                frame: frame,
                handler: { handler in
                    XCTAssertEqual(handler.spots.count, 1)
                    XCTAssertEqual(handler.spots[0].isActive, isActive)
                    XCTAssertEqual(handler.spots[0].frame, frame)
                    expectation.fulfill()
                }
            )
            ViewRenderer(view: view).render()
            wait(for: [expectation], timeout: 0.3)
        }

        func testMultipleHandles() {
            let expectation = XCTestExpectation()
            let view = MultipleHandlesView { handle in
                expectation.fulfill()
                XCTAssertEqual(handle.spots.count, 2)
            }
            ViewRenderer(view: view).render()
            wait(for: [expectation], timeout: 0.3)
        }
    }
}
