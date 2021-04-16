//
//  DrivingScrollViewTests.swift
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
    let isActiveHandler: (Bool) -> Void

    var body: some View {
        Color.green
            .drivingScrollView(isActive)
            .onDrivingScrollViewChange(handler: isActiveHandler)
    }
}

class DrivingScrollViewModifierTests: XCTestCase {

    func testDrivingScrollView() {
        [false, true].forEach { shouldBeActive in
            let expectation = XCTestExpectation()
            let view = ContainerView(
                isActive: shouldBeActive,
                isActiveHandler: { isActive in
                    XCTAssertEqual(isActive, shouldBeActive)
                    expectation.fulfill()
                }
            )
            ViewRenderer(view: view).render()
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
