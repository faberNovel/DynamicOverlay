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
    let layout: OverlayContainerLayout
    let content: UIViewController?
}

class OverlayContainerCoordinator {

    var notchChangeUpdateHandler: ((Int) -> Void)?

    var translationUpdateHandler: ((OverlayContainerTransitionCoordinator) -> Void)?

    private lazy var overlayViewController = OverlayContentViewController()

    typealias State = OverlayContainerState

    private var state: State

    init(initialState: State) {
        self.state = initialState
    }

    // MARK: - Public

    func move(_ container: OverlayContainerViewController, to state: State, animated: Bool) {
        let previous = self.state
        guard state != previous else { return }
        self.state = state
        if container.viewControllers.isEmpty {
            container.viewControllers = [overlayViewController]
        }
        overlayViewController.contentViewController = state.content
        overlayViewController.view.layoutIfNeeded()
        if previous.layout != self.state.layout {
            container.invalidateNotchHeights()
        }
        if let index = state.notchIndex, index != previous.notchIndex {
            container.moveOverlay(toNotchAt: index, animated: animated)
        }
        container.drivingScrollView = overlayViewController.view.findScrollView()
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
}

private extension OverlayContainerState {

    func withNewNotch(_ notch: Int) -> OverlayContainerState {
        OverlayContainerState(notchIndex: notch, layout: layout, content: content)
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
