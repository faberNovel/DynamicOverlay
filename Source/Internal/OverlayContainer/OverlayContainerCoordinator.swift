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
    let searchesScrollView: Bool
    let notchIndex: Int?
    let disabledNotches: Set<Int>
    let layout: OverlayContainerLayout
}

class OverlayContainerCoordinator {

    var notchChangeUpdateHandler: ((Int) -> Void)?

    var translationUpdateHandler: ((OverlayContainerTransitionCoordinator) -> Void)?

    var shouldStartDraggingOverlay: ((OverlayContainerViewController, CGPoint, UICoordinateSpace) -> Bool)?

    private let background: UIViewController
    private let content: UIViewController
    private let animationController: OverlayAnimatedTransitioning

    private let indexMapper = OverlayNotchIndexMapper()

    typealias State = OverlayContainerState

    private var state: State

    // MARK: - Life Cycle

    init(layout: OverlayContainerLayout,
         animationController: OverlayAnimatedTransitioning,
         background: UIViewController,
         content: UIViewController) {
        self.state = State(searchesScrollView: false, notchIndex: nil, disabledNotches: [], layout: layout)
        self.animationController = animationController
        self.background = background
        self.content = content
    }

    // MARK: - Public

    func move(_ container: OverlayContainerViewController, to state: State, animated: Bool) {
        if container.viewControllers.isEmpty {
            container.viewControllers = [background, content]
        }
        let changes = OverlayContainerStateDiffer().diff(
            from: self.state,
            to: state
        )
        let requiresLayoutUpdate = changes.contains(.index) || changes.contains(.layout)
        if requiresLayoutUpdate && animated {
            // we update the content first
            container.drivingScrollView = nil // issue #21
            container.view.layoutIfNeeded()
        }
        if changes.contains(.layout) {
            container.invalidateNotchHeights()
        }
        if let index = state.notchIndex, changes.contains(.index) {
            container.moveOverlay(toNotchAt: index, animated: animated)
        }
        if changes.contains(.scrollView) {
            CATransaction.setCompletionBlock { [weak self] in
                container.drivingScrollView = state.searchesScrollView ?
                self?.content.view.findDrivingScrollViewWrapper()?.findScrollView() :
                nil
            }
        }
        self.state = state
        if changes.contains(.layout) && !animated {
            UIView.performWithoutAnimation {
                container.view.layoutIfNeeded()
            }
        }
    }
}

extension OverlayContainerCoordinator: OverlayContainerViewControllerDelegate {

    // MARK: - OverlayContainerViewControllerDelegate

    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        indexMapper.reload(
            layout: state.layout,
            availableHeight: containerViewController.availableSpace
        )
        return indexMapper.numberOfOverlayIndexes()
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        indexMapper.height(forOverlayIndex: index)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        didMoveOverlay overlayViewController: UIViewController,
                                        toNotchAt index: Int) {
        let newState = state.withNewNotch(index)
        guard newState != state else { return }
        notchChangeUpdateHandler?(
            indexMapper.dynamicIndex(forOverlayIndex: index)
        )
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willTranslateOverlay overlayViewController: UIViewController,
                                        transitionCoordinator: OverlayContainerTransitionCoordinator) {
        translationUpdateHandler?(transitionCoordinator)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        canReachNotchAt index: Int,
                                        forOverlay overlayViewController: UIViewController) -> Bool {
        !state.disabledNotches.map { indexMapper.overlayIndex(forDynamicIndex: $0) }.contains(index)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        shouldStartDraggingOverlay overlayViewController: UIViewController,
                                        at point: CGPoint,
                                        in coordinateSpace: UICoordinateSpace) -> Bool {
        shouldStartDraggingOverlay?(
            containerViewController,
            point,
            coordinateSpace
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
            searchesScrollView: searchesScrollView,
            notchIndex: notch,
            disabledNotches: disabledNotches,
            layout: layout
        )
    }
}

private extension UIView {

    func findDrivingScrollViewWrapper() -> DrivingScrollViewMarkingWrapper? {
        if let scrollView = self as? DrivingScrollViewMarkingWrapper {
            return scrollView
        }
        for subview in subviews {
            if let target = subview.findDrivingScrollViewWrapper() {
                return target
            }
        }
        return nil
    }

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
