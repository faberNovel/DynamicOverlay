//
//  OnDragHandleChangeViewModifier.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

struct OnDragHandleChangeViewModifier: ViewModifier {

    let handler: (DynamicOverlayDragHandle) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(DynamicOverlayDragHandlePreferenceKey.self, perform: handler)
    }
}

extension View {

    func onDragHandleChange(handler: @escaping (DynamicOverlayDragHandle) -> Void) -> some View {
        modifier(OnDragHandleChangeViewModifier(handler: handler))
    }
}
