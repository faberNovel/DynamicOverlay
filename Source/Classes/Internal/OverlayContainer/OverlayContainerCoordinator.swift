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
    let searchsScrollView: Bool
    let notchIndex: Int?
    let disabledNotches: Set<Int>
    let layout: OverlayContainerLayout
}

class OverlayContainerCoordinator {

    var notchChangeUpdateHandler: ((Int) -> Void)?

    var translationUpdateHandler: ((OverlayContainerTransitionCoordinator) -> Void)?

    var shouldStartDraggingOverlay: ((CGPoint) -> Bool)?

    private let content: UIViewController
    private let animationController: OverlayAnimatedTransitioning

    typealias State = OverlayContainerState

    private var state: State

    // MARK: - Life Cycle

    init(layout: OverlayContainerLayout,
         animationController: OverlayAnimatedTransitioning,
         content: UIViewController) {
        self.state = State(searchsScrollView: false, notchIndex: nil, disabledNotches: [], layout: layout)
        self.animationController = animationController
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
        if state.searchsScrollView {
            CATransaction.setCompletionBlock { [weak self] in
                container.drivingScrollView = self?.content.view.findScrollView()
            }
        } else {
            container.drivingScrollView = nil
        }
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
            return containerViewController.availableSpace * dimension.value
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

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        shouldStartDraggingOverlay overlayViewController: UIViewController,
                                        at point: CGPoint,
                                        in coordinateSpace: UICoordinateSpace) -> Bool {
        shouldStartDraggingOverlay?(
            containerViewController.view.convert(point, from: coordinateSpace)
        ) ?? false
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        transitioningDelegateForOverlay overlayViewController: UIViewController) -> OverlayTransitioningDelegate? {
        self
    }
}

extension OverlayContainerCoordinator: OverlayTransitioningDelegate {

    // MARK: - OverlayTransitioningDelegate

    func animationController(for overlayViewController: UIViewController) -> OverlayAnimatedTransitioning? {
        animationController
    }
}

private extension OverlayContainerState {

    func withNewNotch(_ notch: Int) -> OverlayContainerState {
        OverlayContainerState(
            searchsScrollView: searchsScrollView,
            notchIndex: notch,
            disabledNotches: disabledNotches,
            layout: layout
        )
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
