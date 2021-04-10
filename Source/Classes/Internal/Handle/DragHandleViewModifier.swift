//
//  DragHandleViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DragHandleViewModifier: ViewModifier {

    let isActive: Bool

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content.preference(
                key: DynamicOverlayDragHandlePreferenceKey.self,
                value: DynamicOverlayDragHandle(
                    spots: [
                        DynamicOverlayDragHandle.Spot(
                            frame: proxy.frame(in: .overlayContainer),
                            isActive: isActive
                        )
                    ]
                )
            )
        }
    }
}
