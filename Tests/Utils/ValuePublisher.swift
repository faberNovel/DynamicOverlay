//
//  ValuePublisher.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 15/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation

class ValuePublisher<V>: ObservableObject {

    @Published
    var value: V

    init(_ value: V) {
        self.value = value
    }

    func update(_ value: V) {
        self.value = value
    }
}
