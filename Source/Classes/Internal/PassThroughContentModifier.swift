//
//  PassThroughContentModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

private struct EmptyShape: Shape {

    // MARK: - Shape

    func path(in rect: CGRect) -> Path {
        return Path(CGRect.zero)
    }
}

private struct PassThroughContentModifier: ViewModifier {

    func body(content: Content) -> some View {
        content.contentShape(EmptyShape())
    }
}

extension View {

    func passThroughContent() -> some View {
        modifier(PassThroughContentModifier())
    }
}
