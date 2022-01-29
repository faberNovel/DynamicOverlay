//
//  OnDrivingScrollViewChangeViewModifier.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI

private struct OnDrivingScrollViewChangeViewModifier: ViewModifier {

    let handler: (DynamicOverlayScrollViewProxy) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(DynamicOverlayScrollViewProxyPreferenceKey.self, perform: { value in
            handler(DynamicOverlayScrollViewProxy(area: value))
        })
    }
}

extension View {

    func onDrivingScrollViewChange(handler: @escaping (DynamicOverlayScrollViewProxy) -> Void) -> some View {
        modifier(OnDrivingScrollViewChangeViewModifier(handler: handler))
    }
}
