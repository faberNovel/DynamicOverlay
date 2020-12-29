//
//  OverlayNotchIndexMapperTests.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 29/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import XCTest
@testable import DynamicOverlay

class OverlayNotchIndexMapperTests: XCTestCase {

    private var mapper: OverlayNotchIndexMapper!

    override func setUp() {
        self.mapper = OverlayNotchIndexMapper()
    }

    func testAlreadyOrderedIndexesMapping() {
        let layout = OverlayContainerLayout(
            indexToDimension: [
                0: NotchDimension(type: .fractional, value: 0.1),
                1: NotchDimension(type: .fractional, value: 0.2),
                2: NotchDimension(type: .fractional, value: 0.3),
            ]
        )
        mapper.reload(
            layout: layout,
            availableHeight: 200.0
        )
        XCTAssert(mapper.numberOfOverlayIndexes() == 3)
        XCTAssert(mapper.dynamicIndex(forOverlayIndex: 0) == 0)
        XCTAssert(mapper.dynamicIndex(forOverlayIndex: 1) == 1)
        XCTAssert(mapper.dynamicIndex(forOverlayIndex: 2) == 2)
        XCTAssert(mapper.overlayIndex(forDynamicIndex: 0) == 0)
        XCTAssert(mapper.overlayIndex(forDynamicIndex: 1) == 1)
        XCTAssert(mapper.overlayIndex(forDynamicIndex: 2) == 2)
    }

    func testFractionalNotchDimensionReordering() {
        let layout = OverlayContainerLayout(
            indexToDimension: [
                0: NotchDimension(type: .absolute, value: 100),
                1: NotchDimension(type: .fractional, value: 0.1),
            ]
        )
        mapper.reload(
            layout: layout,
            availableHeight: 200.0
        )
        XCTAssert(mapper.numberOfOverlayIndexes() == 2)
        XCTAssert(mapper.dynamicIndex(forOverlayIndex: 0) == 1)
        XCTAssert(mapper.dynamicIndex(forOverlayIndex: 1) == 0)
        XCTAssert(mapper.overlayIndex(forDynamicIndex: 1) == 0)
        XCTAssert(mapper.overlayIndex(forDynamicIndex: 0) == 1)
    }

    func testNotchFractionalHeights() {
        let layout = OverlayContainerLayout(
            indexToDimension: [
                0: NotchDimension(type: .fractional, value: 0.1),
                1: NotchDimension(type: .fractional, value: 0.5),
                2: NotchDimension(type: .fractional, value: 1),
            ]
        )
        mapper.reload(
            layout: layout,
            availableHeight: 200.0
        )
        XCTAssert(mapper.numberOfOverlayIndexes() == 3)
        XCTAssert(mapper.height(forOverlayIndex: 0) == 20.0)
        XCTAssert(mapper.height(forOverlayIndex: 1) == 100.0)
        XCTAssert(mapper.height(forOverlayIndex: 2) == 200.0)
    }
}
