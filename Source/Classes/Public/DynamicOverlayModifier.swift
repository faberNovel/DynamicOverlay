//
//  DynamicOverlayModifier.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 01/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

public extension View {

    /// Sets the overlay behavior for dynamic overlays within this view.
    ///
    /// - parameter behavior: the behavior to apply.
    ///
    /// - returns:A view with the specified behavior set.
    /// 
    /// This modifier affects the given view, as well as that view’s descendant views. It has no effect outside the view hierarchy on which you call it.
    func dynamicOverlayBehavior<Behavior: DynamicOverlayBehavior>(_ behavior: Behavior) -> some View {
        modifier(behavior.makeModifier())
    }
}

public struct AddDynamicOverlayBehaviorModifier: ViewModifier {

    let value: DynamicOverlayBehaviorValue

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content.environment(\.behaviorValue, value)
    }
}
