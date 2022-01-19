//
//  DrivingScrollViewHandle.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 11/01/2022.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import SwiftUI

protocol ScrollViewContainer: AnyObject {
    func scrollView() -> UIScrollView?
}

struct DrivingScrollViewHandle: Equatable {

    private var containers: [Weak<ScrollViewContainer>]

    private init(container: ScrollViewContainer?) {
        self.containers = container.flatMap { [Weak($0)] } ?? []
    }

    static func active(_ container: ScrollViewContainer) -> DrivingScrollViewHandle {
        DrivingScrollViewHandle(
            container: container
        )
    }

    static func inactive() -> DrivingScrollViewHandle {
        DrivingScrollViewHandle(
            container: nil
        )
    }

    mutating func merge(_ reader: DrivingScrollViewHandle) {
        containers.append(contentsOf: reader.containers)
    }

    static var `default`: DrivingScrollViewHandle {
        .inactive()
    }
}

extension DrivingScrollViewHandle {

    func findScrollView() -> UIScrollView? {
        containers.first?.value?.scrollView()
    }
}

struct DynamicOverlayScrollPreferenceKey: PreferenceKey {

    typealias Value = DrivingScrollViewHandle

    static var defaultValue: DrivingScrollViewHandle = .default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}

private struct Weak<T>: Equatable {

    private weak var storage: AnyObject?

    var value: T? {
        storage as? T
    }

    init(_ value: T) {
        self.storage = value as AnyObject
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage === rhs.storage
    }
}
