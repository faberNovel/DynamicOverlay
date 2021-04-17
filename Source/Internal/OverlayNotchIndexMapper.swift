//
//  OverlayNotchIndexMapper.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 29/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

class OverlayNotchIndexMapper {

    private var overlayIndexToDynamicIndex: [Int: Int] = [:]
    private var overlayIndexToHeight: [Int: CGFloat] = [:]
    private var dynamicIndexToOverlayIndex: [Int: Int] = [:]

    func reload(layout: OverlayContainerLayout, availableHeight: CGFloat) {
        overlayIndexToDynamicIndex = [:]
        overlayIndexToHeight = [:]
        dynamicIndexToOverlayIndex = [:]
        let sortedIndexes = layout.indexToDimension.sorted(by: {
            height(for: $0.value, availableHeight: availableHeight) < height(for: $1.value, availableHeight: availableHeight)
        })
        sortedIndexes.enumerated().forEach{ overlayIndex, dynamicValue in
            overlayIndexToHeight[overlayIndex] = height(for: dynamicValue.value, availableHeight: availableHeight)
            dynamicIndexToOverlayIndex[dynamicValue.key] = overlayIndex
            overlayIndexToDynamicIndex[overlayIndex] = dynamicValue.key
        }
    }

    func numberOfOverlayIndexes() -> Int {
        overlayIndexToDynamicIndex.count
    }

    func dynamicIndex(forOverlayIndex index: Int) -> Int {
        dynamicIndexToOverlayIndex[index] ?? 0
    }

    func overlayIndex(forDynamicIndex index: Int) -> Int {
        overlayIndexToDynamicIndex[index] ?? 0
    }

    func height(forOverlayIndex index: Int) -> CGFloat {
        overlayIndexToHeight[index] ?? 0
    }

    private func height(for dimension: NotchDimension,
                        availableHeight: CGFloat) -> CGFloat {
        switch dimension.type {
        case .absolute:
            return CGFloat(dimension.value)
        case .fractional:
            return availableHeight * CGFloat(dimension.value)
        }
    }
}
