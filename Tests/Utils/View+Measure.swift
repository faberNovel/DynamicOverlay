//
//  View+OnHeightCHange.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 15/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

extension View {

    func onHeightChange(_ block: @escaping (CGFloat) -> Void) -> some View {
        onFrameChange { block($0.height) }
    }

    func onFrameChange(in coordinateSpace: CoordinateSpace = .global,
                       _ block: @escaping (CGRect) -> Void) -> some View {
        modifier(OnFrameChangeViewModifier(coordinateSpace: coordinateSpace, block: block))
    }
}

private struct OnFrameChangeViewModifier: ViewModifier {

    let coordinateSpace: CoordinateSpace
    let block: (CGRect) -> Void

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy -> Color in
                let frame = proxy.frame(in: coordinateSpace)
                block(frame)
                return Color.clear
            }
        )
    }
}
