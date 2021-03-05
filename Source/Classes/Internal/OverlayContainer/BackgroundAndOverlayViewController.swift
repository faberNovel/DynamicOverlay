//
//  BackgroundAndOverlayViewController.swift
//  DynamicOverlay
//
//  Created by Ivo Silva on 05.03.21.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI
import OverlayContainer

class BackgroundAndOverlayContainerViewController: OverlayContainerViewController {
    
    private let backgroundViewController: UIViewController
    private let backgroundView = UIView()
    
    init(backgroundViewController: UIViewController, style: OverlayContainerViewController.OverlayStyle) {
        
        self.backgroundViewController = backgroundViewController
        
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.pinToSuperview()
        addChild(backgroundViewController, in: backgroundView)
    }
}

// MARK: - UIKit extensions
// Credits to OverlayContainer - `UIViewController+Children.swift`

private extension UIViewController {
    
    func addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        
        addChild(child)
        containerView.addSubview(child.view)
        child.view.pinToSuperview()
        child.didMove(toParent: self)
    }
}

// Credits to OverlayContainer - `UIView+Constraints.swift`

private extension UIView {
    
    func pinToSuperview(with insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        }
    }
}
