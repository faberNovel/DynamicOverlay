//
//  DrivingScrollViewViewModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

struct DrivingScrollViewViewModifier: ViewModifier {

    let isActive: Bool

    func body(content: Content) -> some View {
        content.preference(key: DynamicOverlayScrollPreferenceKey.self, value: isActive)
    }
}
