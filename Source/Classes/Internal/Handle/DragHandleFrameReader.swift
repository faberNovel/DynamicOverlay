//
//  DragHandleFrameReader.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 11/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI

struct DragHandleFrameReader: View {

    let isActive: Bool

    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: DynamicOverlayDragHandlePreferenceKey.self,
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
