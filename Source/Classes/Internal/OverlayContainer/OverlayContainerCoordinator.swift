//
//  OverlayContainerCoordinator.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import UIKit
import OverlayContainer

struct OverlayContainerLayout: Equatable {
    let indexToDimension: [Int: NotchDimension]
}

struct OverlayContainerState: Equatable {
    let notchIndex: Int?
    let disabledNotches: Set<Int>
    let layout: OverlayContainerLayout
}

class OverlayContainerCoordinator {

    var notchChangeUpdateHandler: ((Int) -> Void)?

    var translationUpdateHandler: ((OverlayContainerTransitionCoordinator) -> Void)?

    private let content: UIViewController

    typealias State = OverlayContainerState

    private var state: State

    init(layout: OverlayContainerLayout, content: UIViewController) {
        self.state = State(notchIndex: nil, disabledNotches: [], layout: layout)
        self.content = content
    }

    // MARK: - Public

    func move(_ container: OverlayContainerViewController, to state: State, animated: Bool) {
        if container.viewControllers.isEmpty {
            container.viewControllers = [content]
        }
        let previous = self.state
        self.state = state
        if previous.layout != state.layout {
            container.invalidateNotchHeights()
        }
        if let index = state.notchIndex, index != previous.notchIndex {
            container.moveOverlay(toNotchAt: index, animated: animated)
        }
        container.drivingScrollView = content.view.findScrollView()
    }
}

extension OverlayContainerCoordinator: OverlayContainerViewControllerDelegate {

    // MARK: - OverlayContainerViewControllerDelegate

    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        state.layout.indexToDimension.count
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        guard let dimension = state.layout.indexToDimension[index] else { return 0 }
        switch dimension.type {
        case .absolute:
            return dimension.value
        case .fractional:
            return availableSpace * dimension.value
        }
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        didMoveOverlay overlayViewController: UIViewController,
                                        toNotchAt index: Int) {
        let newState = state.withNewNotch(index)
        guard newState != state else { return }
        notchChangeUpdateHandler?(index)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willTranslateOverlay overlayViewController: UIViewController,
                                        transitionCoordinator: OverlayContainerTransitionCoordinator) {
        translationUpdateHandler?(transitionCoordinator)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        canReachNotchAt index: Int,
                                        forOverlay overlayViewController: UIViewController) -> Bool {
        !state.disabledNotches.contains(index)
    }
}

private extension OverlayContainerState {

    func withNewNotch(_ notch: Int) -> OverlayContainerState {
        OverlayContainerState(notchIndex: notch, disabledNotches: disabledNotches, layout: layout)
    }
}

private class OverlayContentViewController: UIViewController {

    var contentViewController: UIViewController? {
        didSet {
            loadViewIfNeeded()
            oldValue.flatMap { removeChild($0) }
            contentViewController.flatMap { addChild($0, in: view) }
        }
    }
}

private extension UIView {

    func findScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        for subview in subviews {
            if let target = subview.findScrollView() {
                return target
            }
        }
        return nil
    }
}

private extension UIViewController {

    func addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = true
        child.view.frame = containerView.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }

    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
