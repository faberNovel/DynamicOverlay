//
//  DrivingScrollViewModifierTests.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI
@testable import DynamicOverlay

private struct ContainerView: View {

    let isActive: Bool
    let isActiveHandler: (DynamicOverlayScrollViewProxy) -> Void

    var body: some View {
        ScrollView {
            Color.green
        }
        .overlayCoordinateSpace()
        .drivingScrollView(isActive)
        .onDrivingScrollViewChange(handler: isActiveHandler)
    }
}

private class IdentifiedScrollView: UIScrollView {
    var id = ""
}

class DrivingScrollViewModifierTests: XCTestCase {

    func testScrollViewSearch() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        let layer = UIView(frame: container.bounds)
        container.addSubview(layer)
        let scrollViews = Array(repeating: IdentifiedScrollView(), count: 4)
        for i in scrollViews.indices {
            let scrollView = scrollViews[i]
            scrollView.frame.size.height = container.bounds.height / 2
            scrollView.frame.size.width = container.bounds.width / 2
            scrollView.frame.origin.x = container.bounds.width / 2 * CGFloat(i % 2)
            scrollView.frame.origin.y = i > 1 ? container.bounds.height / 2 : 0
            if i.isMultiple(of: 2) {
                layer.addSubview(scrollView)
            } else {
                container.addSubview(scrollView)
            }
        }
        for scrollView in scrollViews {
            scrollViews.forEach { $0.id = "lure" }
            scrollView.id = "target"
            let proxy = DynamicOverlayScrollViewProxy(
                area: .active(scrollView.frame)
            )
            let scrollView = proxy.findScrollView(in: container) as! IdentifiedScrollView
            XCTAssertEqual(scrollView.id, "target")
        }
    }

    func testDrivingScrollView() {
        [false, true].forEach { shouldBeActive in
            let expectation = XCTestExpectation()
            var window: UIWindow!
            let view = ContainerView(
                isActive: shouldBeActive,
                isActiveHandler: { handle in
                    CATransaction.setCompletionBlock {
                        if shouldBeActive {
                            XCTAssertNotNil(handle.findScrollView(in: window))
                        } else {
                            XCTAssertNil(handle.findScrollView(in: window))
                        }
                        expectation.fulfill()
                    }
                }
            )
            let renderer = ViewRenderer(view: view)
            window = renderer.window
            renderer.render()
            wait(for: [expectation], timeout: 0.1)
        }
    }

    func testNoneDrivingScrollView() {
        let expectation = XCTestExpectation()
        expectation.isInverted = true
        let view = Color.red.onDrivingScrollViewChange { _ in
            expectation.fulfill()
        }
        ViewRenderer(view: view).render()
        wait(for: [expectation], timeout: 0.1)
    }
}
