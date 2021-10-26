//
//  OverlayContainerStateDiffer.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 23/07/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation

struct OverlayContainerStateDiffer {

    struct Changes: OptionSet {
        let rawValue: Int

        static let layout = Changes(rawValue: 1 << 0)
        static let index = Changes(rawValue: 1 << 1)
        static let scrollView = Changes(rawValue: 1 << 2)
    }

    func diff(from previous: OverlayContainerState, to next: OverlayContainerState) -> Changes {
        var changes: Changes = []
        if previous.notchIndex != next.notchIndex {
            changes.insert(.index)
        }
        // issue #21
        // The scroll view depends on the content, we need to first for a potential new scroll view
        // at each update
        changes.insert(.scrollView)
        if previous.layout != next.layout {
            changes.insert(.layout)
        }
        return changes
    }
}
