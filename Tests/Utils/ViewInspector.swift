//
//  ViewInspector.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import UIKit

struct ViewInspector {

    let view: UIView

    func search<V: UIView>(_ type: V.Type) -> V {
        guard let result = view.search(type) else {
            fatalError("\(type) does not exist")
        }
        return result
    }
}

private extension UIView {

    func search<V: UIView>(_ type: V.Type) -> V? {
        if let result = self as? V {
            return result
        }
        for subview in subviews {
            if let target = subview.search(type) {
                return target
            }
        }
        return nil
    }
}
