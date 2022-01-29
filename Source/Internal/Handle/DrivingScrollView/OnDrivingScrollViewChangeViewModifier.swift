//
//  OnDrivingScrollViewChangeViewModifier.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI

private struct OnDrivingScrollViewChangeViewModifier: ViewModifier {

    let handler: (DynamicOverlayDragHandle) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(DynamicOverlayScrollPreferenceKey.self, perform: { value in
            handler(value)
        })
    }
}

extension View {

    func onDrivingScrollViewChange(handler: @escaping (DynamicOverlayDragHandle) -> Void) -> some View {
        modifier(OnDrivingScrollViewChangeViewModifier(handler: handler))
    }
}
