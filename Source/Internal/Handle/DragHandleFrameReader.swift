//
//  DragHandleFrameReader.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 11/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI

struct DragHandleFrameReader<Key: PreferenceKey>: View where Key.Value == DynamicOverlayDragHandle {

    let key: Key.Type
    let isActive: Bool

    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            Spacer().preference(
                key: key,
                value: DynamicOverlayDragHandle(
                    spots: [
                        DynamicOverlayDragHandle.Spot(
                            frame: proxy.frame(in: .overlay),
                            isActive: isActive
                        )
                    ]
                )
            )
        }
    }
}
